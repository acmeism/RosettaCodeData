$ list = "[]"
$ gosub comma_quibbling
$ write sys$output return_string
$
$ list = "[""ABC""]"
$ gosub comma_quibbling
$ write sys$output return_string
$
$ list = "[""ABC"", ""DEF""]"
$ gosub comma_quibbling
$ write sys$output return_string
$
$ list = "[""ABC"", ""DEF"", ""G"", ""H""]"
$ gosub comma_quibbling
$ write sys$output return_string
$
$ exit
$
$ comma_quibbling:
$ list = list - "[" - "]"
$ return_string = "{}"
$ if list .eqs. "" then $ return
$ return_string = "{" + f$element( 0, ",", list ) - """" - """"
$ if f$locate( ",", list ) .eq. f$length( list ) then $ goto done2
$ i = 1
$ loop:
$  word = f$element( i, ",", list ) - """" - """"
$  if word .eqs. "," then $ goto done1
$  return_string = return_string - "^" + "^," + word
$  i = i + 1
$  goto loop
$ done1:
$ return_string = f$element( 0, "^", return_string ) + " and" + ( f$element( 1, "^", return_string ) - "," )
$ done2:
$ return_string = return_string + "}"
$ return
