$ limit = p1
$
$ n = 0
$ h_'n = 1
$ x2 = 2
$ x3 = 3
$ x5 = 5
$ i = 0
$ j = 0
$ k = 0
$
$ n = 1
$ loop:
$  x = x2
$  if x3 .lt. x then $ x = x3
$  if x5 .lt. x then $ x = x5
$  h_'n = x
$  if x2 .eq. h_'n
$  then
$   i = i + 1
$   x2 = 2 * h_'i
$  endif
$  if x3 .eq. h_'n
$  then
$   j = j + 1
$   x3 = 3 * h_'j
$  endif
$  if x5 .eq. h_'n
$  then
$   k = k + 1
$   x5 = 5 * h_'k
$  endif
$  n = n + 1
$  if n .le. limit then $ goto loop
$
$ i = 0
$ loop2:
$  write sys$output h_'i
$  i = i + 1
$  if i .lt. 20 then $ goto loop2
$
$ n = limit - 1
$ write sys$output h_'n
