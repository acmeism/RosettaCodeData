$ p1 = f$integer( p1 )
$ max = p1 * p1
$
$ i = 0
$ r = 1
$ rd = 0
$ c = 1
$ cd = 1
$ loop:
$  a'r'_'c' = i
$  nr = r + rd
$  nc = c + cd
$  if nr .eq. 0 .or. nc .eq. 0 .or. nr .gt. p1 .or. nc .gt. p1 .or. f$type( a'nr'_'nc' ) .nes. ""
$  then
$   gosub change_directions
$  endif
$  r = r + rd
$  c = c + cd
$  i = i + 1
$  if i .lt. max then $ goto loop
$ length = f$length( f$string( max - 1 ))
$ r = 1
$ loop2:
$  c = 1
$  output = ""
$  loop3:
$   output = output + f$fao( "!#UL ", length, a'r'_'c' )
$   c = c + 1
$   if c .le. p1 then $ goto loop3
$  write sys$output output
$  r = r + 1
$  if r .le. p1 then $ goto loop2
$ exit
$
$ change_directions:
$ if rd .eq. 0 .and cd .eq. 1
$ then
$  rd = 1
$  cd = 0
$ else
$  if rd .eq. 1 .and. cd .eq. 0
$  then
$   rd = 0
$   cd = -1
$  else
$   if rd .eq. 0 .and. cd .eq. -1
$   then
$    rd = -1
$    cd = 0
$   else
$    rd = 0
$    cd = 1
$   endif
$  endif
$ endif
$ return
