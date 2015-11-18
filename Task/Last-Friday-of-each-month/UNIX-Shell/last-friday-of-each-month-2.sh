#!/bin/sh

# usage: last_fridays [ year]

year=${1:-`date +%Y`}    # default to current year
month=1
while [ 12 -ge $month ]; do
    # Ensure 2 digits: if we try to strip off 2 characters but it still
    # looks the same, that means there was only 1 char, so we'll pad it.
    [ "$month" = "${month%??}" ] && month=0$month

    cal $month $year | awk '{print $6}' | grep . | tail -1 \
        | sed "s@^@$year-$month-@"

    # Strip leading zeros to avoid octal interpretation
    month=$(( 1 + ${month#0} ))
done
