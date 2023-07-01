$ rnd = f$extract( 21, 2, f$time() )
$ count = 0
$ loop:
$ inquire guess "guess what number between 0 and 99 inclusive I am thinking of"
$ guess = f$integer( guess )
$ if guess .lt. 0 .or. guess .gt. 99
$ then
$  write sys$output "out of range"
$  goto loop
$ endif
$ count = count + 1
$ if guess .lt. rnd then $ write sys$output "too small"
$ if guess .gt. rnd then $ write sys$output "too large"
$ if guess .ne. rnd then $ goto loop
$ write sys$output "it only took you ", count, " guesses"
