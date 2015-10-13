$ if f$search( "input.txt" ) .eqs. ""
$ then
$  write sys$output "input.txt not found"
$ else
$  write sys$output "input.txt found"
$ endif
$ if f$search( "docs.dir" ) .eqs. ""
$ then
$  write sys$output "directory docs not found"
$ else
$  write sys$output "directory docs found"
$ endif
$ if f$search( "[000000]input.txt" ) .eqs. ""
$ then
$  write sys$output "[000000]input.txt not found"
$ else
$  write sys$output "[000000]input.txt found"
$ endif
$ if f$search( "[000000]docs.dir" ) .eqs. ""
$ then
$  write sys$output "directory [000000]docs not found"
$ else
$  write sys$output "directory [000000]docs found"
$ endif
