#!/bin/bash

# Default values (Lowest priority)
config_file="/etc/pomodoro/config.txt"
minutes=25
lock_command="i3lock"
notify_seconds_before_end=60
output_file=""
verbose=false

# First pass: Parse only --config to determine if a config file should be loaded
args=("$@")  # Save original arguments
for ((i = 0; i < $#; i++)); do
    if [[ "${args[i]}" == "--config" ]]; then
        config_file="${args[i+1]}"
        break
    fi
done

# Function to read config file
read_config() {
    local file="$1"
    if [[ -f "$file" ]]; then
        while IFS="=" read -r key value; do
            case "$key" in
                default_minutes) minutes="$value" ;;
                lock_command) lock_command="$value" ;;
                output_file) output_file="$value" ;;
                notify_seconds_before_end) notify_seconds_before_end="$value" ;;
            esac
        done < "$file"
    else
        echo "Warning: Config file not found: $file"
    fi
}

# Load config file if specified
if [[ -n "$config_file" ]]; then
    read_config "$config_file"
fi

# Second pass: Parse other command-line options (Override defaults & config)
while [[ $# -gt 0 ]]; do
    case "$1" in
        --config)  # Already processed, skip
            shift 2
            ;;
        -t)
            minutes="$2"
            shift 2
            ;;
        -n)
            notify_seconds_before_end="$2"
            shift 2
            ;;
        -v)
            verbose=true
            shift 1
            ;;
        *)
            break
            ;;
    esac
done

# Convert minutes to seconds
total_seconds=$(( minutes * 60 ))
seconds_before_notification=$(( total_seconds - notify_seconds_before_end ))
account="Untitled"

if [[ -n "$*" ]]; then
    account="$*"
fi

start_date=$(date "+%F %T")

# Verbose output
if [[ "$verbose" == true ]]; then
    echo "Starting pomodoro"
    echo "Total seconds: $total_seconds"
    echo "Seconds before notification: $seconds_before_notification"
    echo "Account: $account"
    echo "Start date: $start_date"
    echo "Config file: $config_file"
    echo "Lock command: $lock_command"
    echo "Output file: $output_file"
fi

set_start_date() {
    start_date=$(date "+%F %T")
}

write() {
    log_entry="i $start_date $account"$'\n'"o $(date "+%F %T")"
    if [[ -n "$output_file" ]]; then
        echo "$log_entry" >> "$output_file"
    else
        echo "$log_entry"
    fi
}

set_remaining_seconds() {
    seconds=$(( total_seconds - SECONDS ))
}

# Trap EXIT to log session but NOT lock
trap write EXIT

# Function to send a notification
send_notification() {
    echo "Sending notification: $notify_seconds_before_end seconds left!"
    notify-send "Pomodoro Timer" "Only $notify_seconds_before_end seconds left!"
}

# Function to lock screen when time is up
lock_screen() {
    echo "Time's up! Locking screen..."
    eval "$lock_command"
}

# Schedule the notification if `notify_seconds_before_end` is set
if [[ "$notify_seconds_before_end" -gt 0 && "$notify_seconds_before_end" -lt "$total_seconds" ]]; then
    ( sleep "$seconds_before_notification" && send_notification ) &
fi

# Schedule lock screen when time is up
( sleep "$total_seconds" && lock_screen ) &

# Main loop to accept new accounts
while read -r -t "$seconds" new_account; do
    if [[ -n $new_account ]]; then
        write
        account="$new_account"
        set_start_date
        set_remaining_seconds
    fi
done

# Wait for background processes to finish before exiting
wait
