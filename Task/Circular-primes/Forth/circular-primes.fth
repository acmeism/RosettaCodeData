create 235-wheel 6 c, 4 c, 2 c, 4 c, 2 c, 4 c, 6 c, 2 c,
    does> swap 7 and + c@ ;

0 1 2constant init-235    \ roll 235 wheel at position 1
: next-235   over 235-wheel + swap 1+ swap ;

\ check that n is prime excepting multiples of 2, 3, 5.
: sq  dup * ;
: wheel-prime? ( n -- f )
    >r init-235 begin
        next-235
        dup sq r@ >    if  rdrop 2drop true  exit  then
        r@ over mod 0= if  rdrop 2drop false exit  then
    again ;

: prime? ( n -- f )
    dup 2 < if drop false exit then
    dup 2 mod 0= if 2 = exit then
    dup 3 mod 0= if 3 = exit then
    dup 5 mod 0= if 5 = exit then
    wheel-prime? ;

: log10^ ( n -- 10^[log n], log n )
    dup 0<= abort" log10^: argument error."
    1 0 rot
    begin dup 9 > while
        >r  swap 10 *  swap 1+  r> 10 /
    repeat drop ;

: log10  ( n -- n )  log10^ nip ;

: rotate ( n -- n )
    dup log10^ drop /mod swap 10 * + ;

: prime-rotation? ( p0 p -- f )
    tuck <= swap prime? and ;

: circular? ( n -- f )  \ assume n is not a multiple of 2, 3, 5
    dup wheel-prime? invert
    if  drop false exit
    then dup >r true
    over log10 0 ?do
        swap rotate j over prime-rotation? rot and
    loop nip rdrop ;

: .primes
    2 . 3 . 5 .
    16 init-235  \ -- count, [n1 n2] as 2,3,5 wheel
    begin
        next-235 dup circular?
        if dup . rot 1- -rot
        then
    third 0= until 2drop drop ;

." The first 19 circular primes are:" cr .primes cr
bye
