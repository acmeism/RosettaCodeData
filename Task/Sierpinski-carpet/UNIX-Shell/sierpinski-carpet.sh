#!/bin/bash

sierpinski_carpet() {
    local -i n="${1:-3}"
    local carpet="${2:-#}"
    while (( n-- )); do
       local center="${carpet//#/ }"
       carpet="$(paste -d ' ' <(echo "$carpet"$'\n'"$carpet"$'\n'"$carpet")  <(echo "$carpet"$'\n'"$center"$'\n'"$carpet")  <(echo "$carpet"$'\n'"$carpet"$'\n'"$carpet"))"
    done
    echo "$carpet"
}
