#!/bin/sh

i=99 s=s

while [ $i -gt 0 ]; do
        echo "$i bottle$s of beer on the wall"
        echo "$i bottle$s of beer
Take one down, pass it around"
        # POSIX allows for $(( i - 1 )) but some older Unices didn't have that
        i=`expr $i - 1`
	[ $i -eq 1 ] && s= || s=s
        echo "$i bottle$s of beer on the wall
"
done
