#! /bin/bash

declare -a doors
for((i=1; i <= 100; i++)); do
    doors[$i]=0
done

for((i=1; i <= 100; i++)); do
    for((j=i; j <= 100; j += i)); do
	echo $i $j
	doors[$j]=$(( doors[j] ^ 1 ))
    done
done

for((i=1; i <= 100; i++)); do
    if [[ ${doors[$i]} -eq 0 ]]; then
	op="closed"
    else
	op="open"
    fi
    echo $i $op
done
