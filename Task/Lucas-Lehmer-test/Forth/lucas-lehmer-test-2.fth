18 constant π-64  \ count of primes < 64
31 constant π-128 \ count of primes < 128

create primes
      2 c,  3 c,  5 c,  7 c, 11 c,  13 c,  17 c,  19 c,  23 c,  29 c,
     31 c, 37 c, 41 c, 43 c, 47 c,  53 c,  59 c,  61 c,  67 c,  71 c,
     73 c, 79 c, 83 c, 89 c, 97 c, 101 c, 103 c, 107 c, 109 c, 113 c,
    127 c,

\ Lucas-Lehmer single precision test for 64 bit integers.
\
: *mod  >r um* r> ud/mod 2drop ;
: 3rd  s" 2 pick" evaluate ; immediate
: 2^  1 swap lshift ;

: lucas-lehmer?  ( n -- n )
    dup 3 <
    if 2 =
    else
        dup 2^ 1- 4
        rot 2 do  dup 3rd *mod 2 -  loop 0= nip
    then ;

: .mersenne64 ( -- )
    primes π-64 bounds do
        i c@ lucas-lehmer?
        if 'M emit i c@ .  then
    loop ;


\ Lucas-Lehmer double precision test for 128 bit integers.
\
: 4dup  2over 2over ;
: 2-3rd  5 pick 5 pick ;
: d2^ ( n -- d )
    dup 64 <
    if    2^ 0
    else  0 swap 64 - 2^
    then ;
: d+mod ( d1 d2 d3 -- d ) \ d1 + d2 (mod d3); d1, d2 < d3
    2-3rd 2over 2swap d- \ d1 d2 d3 -- d1 d2 d3 d3-d1
    2-3rd d> \ if d2 < d3-d1 then don't subtract the modulus.
    if 2drop 0.
    then d- d+ ;
: d-even?  ( d -- f )
    drop 1 and 0= ;
: d*mod ( d1 d2 d3 -- d )
    2>r 0. \ result
    begin 2over d0> while
        2over d-even? invert  if  2-3rd 2r@ d+mod  then
        2swap d2/ 2swap
        2rot 2dup 2r@ d+mod 2rot 2rot
    repeat 2rdrop 2nip 2nip ;

: d-lucas-lehmer?  ( n -- n )
    dup 3 <
    if 2 =
    else
        dup d2^ 1. d- 4.
        4 roll 2 do  2dup 2-3rd d*mod 2. d-  loop d0= nip nip
    then ;

: .mersenne128 ( -- )
    primes π-128 bounds do
        i c@ d-lucas-lehmer?
        if 'M emit i c@ .  then
    loop ;
