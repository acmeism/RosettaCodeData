$ p1 = f$integer( p1 )
$ if p1 .lt. 2
$ then
$  write sys$output "out of range 2 thru 2^31-1"
$  exit
$ endif
$
$ close /nolog primes
$ on control_y then $ goto clean
$ open primes primes.txt
$
$ loop1:
$  read /end_of_file = prime primes prime
$  prime = f$integer( prime )
$  loop2:
$   t = p1 / prime
$   if t * prime .eq. p1
$   then
$    if f$type( factorization ) .eqs. ""
$    then
$     factorization = f$string( prime )
$    else
$     factorization = factorization + "*" + f$string( prime )
$    endif
$    if t .eq. 1 then $ goto done
$    p1 = t
$    goto loop2
$   else
$    goto loop1
$   endif
$ prime:
$ if f$type( factorization ) .eqs. ""
$ then
$  factorization = f$string( p1 )
$ else
$  factorization = factorization + "*" + f$string( p1 )
$ endif
$ done:
$ show symbol factorization
$ if f$locate( "*", factorization ) .eq. f$length( factorization )
$ then
$  write sys$output "so, it is prime"
$ else
$  if f$element( 2, "*", factorization ) .eqs. "*" then $ write sys$output "so, it is semiprime"
$ endif
$
$ clean:
$ close primes
