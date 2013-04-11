#!/bin/ksh
# tested with pdksh

integer a=0
integer b=0

read a?"Enter value of a: " || { print -u2 "Input of a aborted." ; exit 1 ; }
read b?"Enter value of b: " || { print -u2 "Input of b aborted." ; exit 1 ; }

if (( a < b )) ; then
    printf "%d is less than %d\n" $a $b
fi
if (( a == b )) ; then
    printf "%d is equal to %d\n" $a $b
fi
if (( a > b )) ; then
    printf "%d is greater than %d\n" $a $b
fi

exit 0
