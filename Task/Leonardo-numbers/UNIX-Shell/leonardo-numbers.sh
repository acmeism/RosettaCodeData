#!/bin/bash

function leonardo_number () {
    L0_value=${2:-1}
    L1_value=${3:-1}
    Add=${4:-1}
    leonardo_numbers=($L0_value $L1_value)
    for (( i = 2; i < $1; ++i))
    do
       leonardo_numbers+=( $((leonardo_numbers[i-1] + leonardo_numbers[i-2] + Add)) )
    done
    echo "${leonardo_numbers[*]}"
}
