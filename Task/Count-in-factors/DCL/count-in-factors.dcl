$ close /nolog primes
$ on control_y then $ goto clean
$
$ n = 1
$ outer_loop:
$  x = n
$  open primes primes.txt
$
$  loop1:
$   read /end_of_file = prime primes prime
$   prime = f$integer( prime )
$   loop2:
$    t = x / prime
$    if t * prime .eq. x
$    then
$     if f$type( factorization ) .eqs. ""
$     then
$      factorization = f$string( prime )
$     else
$      factorization = factorization + "*" + f$string( prime )
$     endif
$     if t .eq. 1 then $ goto done
$     x = t
$     goto loop2
$    else
$     goto loop1
$    endif
$ prime:
$  if f$type( factorization ) .eqs. ""
$  then
$   factorization = f$string( x )
$  else
$   factorization = factorization + "*" + f$string( x )
$  endif
$ done:
$  write sys$output f$fao( "!4SL = ", n ), factorization
$  delete /symbol factorization
$  close primes
$  n = n + 1
$  if n .le. 2144 then $ goto outer_loop
$  exit
$
$ clean:
$ close /nolog primes
