#!/bin/bash

flag=
minutes=25
notify_seconds_before_end=

while getopts "t:n:" flag; do
    case "${flag}" in
        t) minutes=$OPTARG;;
        n) notify_seconds_before_end=$OPTARG;;
        *) exit 1;;
    esac
done

total_seconds=$(( minutes * 60 ))
seconds=$total_seconds
seconds_before_notification=$(( total_seconds - notify_seconds_before_end ))
account=Untitled

shift $(("${OPTIND}" - 1))

if [ -n "$*" ]; then
    account="$*"
fi

start_date=$( date "+%F %T" )

set_start_date () {
    start_date=$( date "+%F %T" )
}

write () {
    echo i "$start_date" "$account"
    echo o "$( date "+%F %T" )"
}

set_remaining_seconds () {
    seconds=$(( total_seconds - SECONDS ))
}

trap write EXIT

while read -r -t "$seconds" new_account; do
    if [[ -n $new_account ]]; then
        write

        account=$new_account

        set_start_date
        set_remaining_seconds
    fi
done
