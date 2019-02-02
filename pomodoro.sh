#!/bin/bash

flag=
minutes=25
seconds=$(( 25 * 60 ))
account=Untitled

while getopts "t:" flag; do
    case "${flag}" in
        t) minutes=$OPTARG;;
        *) exit 1;;
    esac
done

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

while read -r -t "$minutes" new_account; do
    write

    account=$new_account

    set_start_date
    set_remaining_seconds
done

write
