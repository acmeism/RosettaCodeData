#!/usr/bin/sed -f

G
:loop
s/^[[:space:]]*\([^[:space:]][^[:space:]]*\)\(.*\n\)/\2 \1/
t loop
s/^[[:space:]]*//
