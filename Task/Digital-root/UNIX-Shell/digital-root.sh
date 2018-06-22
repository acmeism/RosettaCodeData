#!/usr/bin/env bash

numbers=(627615 39390 588225 393900588225 55)
declare root

for number in "${numbers[@]}"; do
    declare -i iterations
    root="${number}"
    while [[ "${#root}" -ne 1 ]]; do
        root="$(( $(fold -w1 <<<"${root}" | xargs | sed 's/ /+/g') ))"
        iterations+=1
    done
    echo -e "${number} has additive persistence ${iterations} and digital root ${root}"
    unset iterations
done | column -t
