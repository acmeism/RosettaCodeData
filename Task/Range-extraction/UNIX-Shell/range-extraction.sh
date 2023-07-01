#!/usr/bin/bash

range_contract () (
    add_range () {
        case $(( current - range_start )) in
            0) ranges+=( $range_start )          ;;
            1) ranges+=( $range_start $current ) ;;
            *) ranges+=("$range_start-$current") ;;
        esac
    }

    ranges=()
    range_start=$1
    current=$1
    shift

    for number; do
        if (( number > current+1 )); then
            add_range
            range_start=$number
        fi
        current=$number
    done
    add_range

    x="${ranges[@]}"
    echo ${x// /,}
)

range_contract 0 1 2 4 6 7 8 11 12 14 15 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 32 33 35 36 37 38 39
