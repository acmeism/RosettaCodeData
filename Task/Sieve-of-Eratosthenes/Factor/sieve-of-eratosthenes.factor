USING: bit-arrays io kernel locals math math.functions
math.ranges prettyprint sequences ;
IN: rosetta-code.sieve-of-erato

<PRIVATE

: init-sieve ( n -- seq )   ! Include 0 and 1 for easy indexing.
    1 - <bit-array> dup set-bits ?{ f f } prepend ;

! Given the sieve and a prime starting index, create a range of
! values to mark composite. Start at the square of the prime.
: to-mark ( seq n -- range )
    [ length 1 - ] [ dup dup * ] bi* -rot <range> ;

! Mark multiples of prime n as composite.
: mark-nths ( seq n -- )
    dupd to-mark [ swap [ f ] 2dip set-nth ] with each ;

: next-prime ( index seq -- n ) [ t = ] find-from drop ;

PRIVATE>

:: sieve ( n -- seq )
    n sqrt 2 n init-sieve :> ( limit i! s )
    [ i limit < ]             ! sqrt optimization
    [ s i mark-nths i 1 + s next-prime i! ] while t s indices ;

: sieve-demo ( -- )
    "Primes up to 120 using sieve of Eratosthenes:" print
    120 sieve . ;

MAIN: sieve-demo
