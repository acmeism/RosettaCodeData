$ x = p1
$ count = 0
$ sum = x
$ loop1:
$  length = f$length( x )
$  if length .eq. 1 then $ goto done
$  i = 0
$  sum = 0
$  loop2:
$   digit = f$extract( i, 1, x )
$   sum = sum + digit
$   i = i + 1
$   if i .lt. length then $ goto loop2
$  x = f$string( sum )
$  count = count + 1
$  goto loop1
$ done:
$ write sys$output p1, " has additive persistence ", count, " and digital root of ", sum
