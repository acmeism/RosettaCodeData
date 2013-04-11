#!/bin/bash
# Usage example: . interpolate "Mary has a X lamb" "quite annoying"
echo "$1" | sed "s/ X / $2 /g"
