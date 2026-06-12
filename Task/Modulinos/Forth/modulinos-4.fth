#! /usr/bin/env forthscript

42 constant Douglas-Adams

s" forthscript" 0 arg compare 0= [IF]
  .( The meaning of life is ) Douglas-Adams . cr bye
[THEN]

cr .( Why aren't you running this as a script?  It only provides a constant.)
