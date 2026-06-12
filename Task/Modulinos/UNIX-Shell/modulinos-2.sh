#!/bin/bash

path=$(dirname -- "$0")
source "$path/scriptedmain"

meaning_of_life
echo "Test: The meaning of life is $?"
