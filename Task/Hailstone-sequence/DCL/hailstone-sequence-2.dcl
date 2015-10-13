$ limit = f$integer( p1 )
$ i = 1
$ max_so_far = 0
$ loop:
$  call hailstone 'i quiet
$  if sequence_length .gt. max_so_far
$  then
$   max_so_far = sequence_length
$   current_record_holder = i
$  endif
$  i = i + 1
$  if i .lt. limit then $ goto loop
$ write sys$output current_record_holder, " is the number less than ", limit, " which has the longest hailstone sequence which is ", max_so_far, " in length"
$ exit
$
$ hailstone: subroutine
$ n = f$integer( p1 )
$ i = 1
$ loop:
$  if p2 .nes. "QUIET" then $ s'i = n
$  if n .eq. 1 then $ goto done
$  i = i + 1
$  if .not. n
$  then
$   n = n / 2
$  else
$   if n .gt. 715827882 then $ exit  ! avoid overflowing
$   n = 3 * n + 1
$  endif
$  goto loop
$ done:
$ if p2 .nes. "QUIET"
$ then
$  penultimate_i = i - 1
$  antepenultimate_i = i - 2
$  preantepenultimate_i = i - 3
$  write sys$output "sequence has ", i, " elements starting with ", s1, ", ", s2, ", ", s3, ", ", s4, " and ending with ", s'preantepenultimate_i, ", ", s'antepenultimate_i, ", ", s'penultimate_i, ", ", s'i
$ endif
$ sequence_length == I
$ exit
$ endsubroutine
