: circle ( x y r h -- f )
rot - dup *
rot   dup * +
swap  dup * swap
< invert
;

: pixel ( r x y -- r c )
2dup 4 pick 6 / 5 pick 2 / negate circle if 2drop '#' exit then
2dup 4 pick 6 / 5 pick 2 /        circle if 2drop '.' exit then
2dup 4 pick 2 / 5 pick 2 / negate circle if 2drop '.' exit then
2dup 4 pick 2 / 5 pick 2 /        circle if 2drop '#' exit then
2dup 4 pick     0 circle if
   drop 0< if '.' exit else '#' exit then
   then
2drop bl
;

: yinyang ( r -- )
dup dup 1+ swap -1 * do
   cr
   dup dup 2 * 1+ swap -2 * do
      I 2 / J  pixel emit
   loop
loop drop
;
