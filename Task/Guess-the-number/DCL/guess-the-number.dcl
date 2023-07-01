$ time = f$time()
$ number = f$extract( f$length( time ) - 1, 1, time ) + 1
$ loop:
$  inquire guess "enter a guess (integer 1-10) "
$  if guess .nes. number then $ goto loop
$ write sys$output "Well guessed!"
