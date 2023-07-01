#!/bin/bash
export LC_ALL=C
# Generate $1 pseudo-random integers of width $2.
# The integers may have leading 0s
function prng {
  cat /dev/urandom | tr -cd '0-9' | fold -w "$2" | head -n "$1"
}

PTS=30000
prng $((4 * PTS)) 3 | jq -nr --argjson PTS $PTS -f k-means++-clustering.jq
