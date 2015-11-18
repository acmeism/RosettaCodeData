$ list = "1,2,3,4,5"
$ call reduce list "+"
$ show symbol result
$
$ numbers = "5,4,3,2,1"
$ call reduce numbers "-"
$ show symbol result
$
$ call reduce list "*"
$ show symbol result
$ exit
$
$ reduce: subroutine
$ local_list = 'p1
$ value = f$integer( f$element( 0, ",", local_list ))
$ i = 1
$ loop:
$  element = f$element( i, ",", local_list )
$  if element .eqs. "," then $ goto done
$  value = value 'p2 f$integer( element )
$  i = i + 1
$  goto loop
$ done:
$ result == value
$ exit
$ endsubroutine
