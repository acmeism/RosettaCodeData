$ list = "123,12345,1234567,987654321,10001,-10001,-123,-100,100,-12345,1,2,-1,-10,2002,-2002,0"
$ i = 0
$ loop:
$  number = f$element( i, ",", list )
$  if number .eqs. "," then $ exit
$  abs_number = number - "-"
$  len = f$length( abs_number )
$  if len .lt. 3 .or. .not. len
$  then
$   write sys$output f$fao( "!9SL: ", f$integer( number )), "has no middle three"
$  else
$   write sys$output f$fao( "!9SL: ", f$integer( number )), f$extract( ( len - 3 ) / 2, 3, abs_number )
$  endif
$  i = i + 1
$  goto loop
