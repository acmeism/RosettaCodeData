#!/bin/sed -f

/^.\{10\}/!d
/^[aeiou]\{0,1\}\([^aeiou][aeiou]\)*[^aeiou]\{0,1\}$/!d
