$ first_string = p1
$ length_of_first_string = f$length( first_string )
$ second_string = p2
$ length_of_second_string = f$length( second_string )
$ offset = f$locate( second_string, first_string )
$ if offset .eq. 0
$ then
$  write sys$output "first string starts with second string"
$ else
$  write sys$output "first string does not start with second string"
$ endif
$ if offset .ne. length_of_first_string
$ then
$  write sys$output "first string contains the second string at location ", offset
$ else
$  write sys$output "first string does not contain the second string at any location"
$ endif
$ temp = f$extract( length_of_first_string - length_of_second_string, length_of_second_string, first_string )
$ if second_string .eqs. temp
$ then
$  write sys$output "first string ends with the second string"
$ else
$  write sys$output "first string does not end with the second string"
$ endif
