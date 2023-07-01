variable p-start  \ beginning of prime buffer
variable p-end    \ end of prime buffer

: +prime  ( n -- )
    p-end @ tuck !  cell+ p-end ! ;

: setup-pgen ( addr n -- n )
    dup 3 < abort" The buffer must be large enough to store at least three primes."
    swap dup p-start !  p-end !
    2 +prime  3 +prime  5 +prime  3 - ;

: sq  s" dup *" evaluate ; immediate

: prime? ( n -- f ) \ test a candidate for primality.
    >r p-start @ [ 2 cells ] literal + begin
        dup @ dup  ( a -- a n n )
        sq r@ >         if rdrop 2drop true  exit then
        r@ swap mod 0=  if rdrop  drop false exit then
        cell+
    again ;

: ?+prime  ( n1 n2 -- n1 n2 )  \ add n2 to output array if prime and n1 != 0
    dup prime? over 0<> and
    if
        dup +prime swap 1- swap
    then ;

: genprimes ( addr n -- )  \ store first n primes at address "addr"
    setup-pgen 7  \ stack:  #found, candidate
    begin
        ?+prime 4 +  ?+prime 2 +
    over 0= until 2drop ;

: .primes ( n -- )
    pad swap 2dup genprimes
    cells bounds do
        i pad - [ 10 cells ] literal mod 0= if  cr  then
        i @ 5 .r
    cell +loop ;
