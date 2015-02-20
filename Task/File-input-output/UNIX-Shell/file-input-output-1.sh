#!/bin/sh
while IFS= read -r a; do
    printf '%s\n' "$a"
done <input.txt >output.txt
