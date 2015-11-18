$ open input input.txt
$ open /write output output.txt
$ loop:
$  read /end_of_file = done input line
$  write output line
$  goto loop
$ done:
$ close input
$ close output
