$ max = 12
$ h = f$fao( "!4* " )
$ r = 0
$ loop1:
$  o = ""
$  c = 0
$  loop2:
$   if r .eq. 0 then $ h = h + f$fao( "!4SL", c )
$   p = r * c
$   if c .ge. r
$   then
$    o = o + f$fao( "!4SL", p )
$   else
$    o = o + f$fao( "!4* " )
$   endif
$   c = c + 1
$   if c .le. max then $ goto loop2
$  if r .eq. 0
$  then
$   write sys$output h
$   n = 4 * ( max + 2 )
$   write sys$output f$fao( "!''n*-" )
$  endif
$  write sys$output f$fao( "!4SL", r ) + o
$  r = r + 1
$  if r .le. max then $ goto loop1
