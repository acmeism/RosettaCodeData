#!/bin/ksh
# Temperature conversion
set -A tt 0.00 273.15 373.15
for t in "${tt[@]}"
do
    echo
    echo "Kelvin:     $t K"
    echo "Celsius:    $((t-273.15)) C"
    echo "Fahrenheit: $((t*18/10-459.67)) F"
    echo "Rankine:    $((t*18/10)) R"
done
