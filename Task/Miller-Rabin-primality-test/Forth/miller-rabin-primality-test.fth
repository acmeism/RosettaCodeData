\ modular multiplication and exponentiation
\
: 3rd  s" 2 pick" evaluate ; immediate

: mod*  ( a b m -- a*b {mod m} )
    >r um* r> ud/mod 2drop ;

: mod^  ( x n m -- x^n {mod m} )
    >r 1 swap
    begin ?dup while
        dup 1 and 1 =
        if
            swap 3rd r@ mod* swap 1-
        then dup 0>
        if
            rot dup r@ mod* -rot 2/
        then
    repeat nip rdrop ;

\ small divisor check: true => possibly prime; false => definitely not prime.
\
31 constant π-128
create maybe-prime?
      2 c,  3 c,  5 c,  7 c, 11 c,  13 c,  17 c,  19 c,  23 c,  29 c,
     31 c, 37 c, 41 c, 43 c, 47 c,  53 c,  59 c,  61 c,  67 c,  71 c,
     73 c, 79 c, 83 c, 89 c, 97 c, 101 c, 103 c, 107 c, 109 c, 113 c,
    127 c,
does>
    true -rot
    π-128 bounds do
        i c@ dup * over > if leave then
        dup i c@ mod 0= if 2drop false unloop exit then
    loop drop ;

\ actual Miller-Rabin test
\
: factor-2s  ( n -- s d )
    0 swap
    begin dup 1 and 0= while
        swap 1+  swap 2/
    repeat ;

: fermat-square-test ( n m s -- ? ) \ perform n = n^2 (mod m), s-1 times
    1- 0 ?do
        2dup - -1 =
        if   leave
        then >r dup r@ mod* r>
    loop
    - -1 = ;

: strong-fermat-pseudoprime? ( n a -- ? )
    over >r \ keep the modulus on the return stack
    >r 1- factor-2s r>  \ -- s d a
    swap r@ mod^        \ s d a -- s, a^d (mod n)
    dup 1 =             \ a^d == 1 (mod n) => Fermat pseudoprime
    if   2drop rdrop true
    else r> rot fermat-square-test
    then ;

4.759.123.141 drop constant mr-det-3   \ Deterministic threshold; 3 bases

create small-prime-bases 2 , 7 , 61 ,  \ deterministic up to mr-det-3
create large-prime-bases 2 , 325 , 9375 , 28178 , 450775 , 9780504 , 1795265022 , \ known to be deterministic for 64 bit integers.

: miler-rabin-bases ( n -- addr n )
    mr-det-3 <
    if    small-prime-bases 3
    else  large-prime-bases 7
    then ;

: miller-rabin-primality-test ( n -- f )
    dup miler-rabin-bases cells bounds do
        dup i @ strong-fermat-pseudoprime? invert
        if drop false unloop exit then
    cell +loop drop true ;

: prime? ( n -- f )
    dup 2 <
    if drop false
    else
        dup maybe-prime?
        if dup [ 127 dup * 1+ ] literal <
            if   drop true
            else miller-rabin-primality-test
            then
        else drop false
        then
    then ;
