$! in DCL, for integers, the least significant bit determines the logical value, where 1 is true and 0 is false
$
$ i = -5
$ loop1:
$  if i then $ write sys$output i, " is odd"
$  if .not. i then $ write sys$output i, " is even"
$  i = i + 1
$  if i .le. 6 then $ goto loop1
