#!/bin/bash
< /dev/random tr -cd '0-9' | fold -w 1 | jq -Mcnr -f random-latin-squares.jq
