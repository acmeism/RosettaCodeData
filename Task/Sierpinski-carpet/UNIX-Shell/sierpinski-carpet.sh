#!/bin/bash

next() {
    block="$1"
    center="$(echo "$1" | tr '#' ' ')"
    paste -d '' <(echo "$block") <(echo "$block" ) <(echo "$block")
    paste -d '' <(echo "$block") <(echo "$center") <(echo "$block")
    paste -d '' <(echo "$block") <(echo "$block" ) <(echo "$block")
}

carpet="#"
for _ in {1..3}
do
  carpet="$(next "$carpet")"
done

echo "$carpet"
