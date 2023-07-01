#! /usr/bin/gforth-fast

: reverse  ( n -- n )
    0 swap
    begin
        10 /mod >r  swap 10 * +
    r> dup 0= until drop ;

: 2^  1 swap lshift ;

create 235-wheel 6 c, 4 c, 2 c, 4 c, 2 c, 4 c, 6 c, 2 c,
    does> swap 7 and + c@ ;

0  1 2constant init-235    \ roll 235 wheel at position 1
2 11 2constant emirp-start \ starting position to roll wheel for emirp search.

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
    dup 2 <
    if drop false
    else
        dup 1 and 0=
        if 2 =
        else dup 3 mod 0=
            if 3 =
            else dup 5 mod 0=
                if 5 =
                else wheel-prime?
                then
            then
        then
    then ;

: emirp? ( n -- f )
    dup reverse 2dup <>
    swap prime? and
    swap wheel-prime? and ;

: next-emirp ( m n -- m' n' )
    begin
        next-235
    dup emirp? until ;


: task1
    cr ." The first 20 emirps are: " 0 { count }
    emirp-start begin
        next-emirp dup .
        count 1+ dup to count
    20 = until 2drop ;

: task2
    cr ." emirps between 7700 and 8000: "
    emirp-start begin
        next-emirp dup 7700 8000 within if dup . then
    dup 8000 > until 2drop ;

: task3
    cr ." The 10,000th emirp is " 0 { count }
    emirp-start begin
        next-emirp
        count 1+ dup to count
    10000 = until nip . ;

task1 task2 task3
cr bye
