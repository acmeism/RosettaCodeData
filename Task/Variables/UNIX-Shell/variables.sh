#!/bin/sh
# The unix shell uses typeless variables
apples=6
# pears=5+4           # Some shells cannot perform addition this way
pears = `expr 5+4`    # We use the external expr to perform the calculation
myfavourite="raspberries"
