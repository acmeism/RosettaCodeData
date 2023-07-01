$ list = "45,65,81,12,0,13,-56,123,-123,888,12,0"
$ max = f$integer( f$element( 0, ",", list ))
$ i = 1
$ loop:
$  element = f$element( i, ",", list )
$  if element .eqs. "," then $ goto done
$  element = f$integer( element )
$  if element .gt. max then $ max = element
$  i = i + 1
$  goto loop
$ done:
$ show symbol max
