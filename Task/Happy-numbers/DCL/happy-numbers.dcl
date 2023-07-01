$ happy_1 = 1
$ found = 0
$ i = 1
$ loop1:
$  n = i
$  seen_list = ","
$  loop2:
$   if f$type( happy_'n ) .nes. "" then $ goto happy
$   if f$type( unhappy_'n ) .nes. "" then $ goto unhappy
$   if f$locate( "," + n + ",", seen_list ) .eq. f$length( seen_list )
$   then
$    seen_list = seen_list + f$string( n ) + ","
$   else
$    goto unhappy
$   endif
$   ns = f$string( n )
$   nl = f$length( ns )
$   j = 0
$   sumsq = 0
$   loop3:
$    digit = f$integer( f$extract( j, 1, ns ))
$    sumsq = sumsq + digit * digit
$    j = j + 1
$    if j .lt. nl then $ goto loop3
$    n = sumsq
$   goto loop2
$  unhappy:
$  j = 1
$  loop4:
$   x = f$element( j, ",", seen_list )
$   if x .eqs. "" then $ goto continue
$   unhappy_'x = 1
$   j = j + 1
$   goto loop4
$  happy:
$  found = found + 1
$  found_'found = i
$  if found .eq. 8 then $ goto done
$  j = 1
$  loop5:
$   x = f$element( j, ",", seen_list )
$   if x .eqs. "" then $ goto continue
$   happy_'x = 1
$   j = j + 1
$   goto loop5
$  continue:
$  i = i + 1
$  goto loop1
$ done:
$ show symbol found*
