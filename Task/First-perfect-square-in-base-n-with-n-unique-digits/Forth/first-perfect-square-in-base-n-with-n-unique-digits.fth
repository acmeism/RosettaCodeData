#! /usr/bin/gforth-fast

: 2^  1 swap lshift ;

: sq  s" dup *" evaluate ; immediate

: min-root  ( -- n )  \ minimum root that can be pandigitial
    base @ s>f fdup 1e f- 0.5e f* f** f>s ;

: pandigital? ( n -- f )
    0 swap  \ bitmask
    begin
        base @ /mod
        >r 2^ or r>
    dup 0= until drop
    base @ 2^ 1- = ;

: panroot ( -- n ) \ get the minimum square root using the variable BASE.
    min-root 1- begin
        1+
    dup sq pandigital? until ;

: .squares ( -- )
    base @ 17 2 do
        i base !
        i 2 dec.r 3 spaces panroot dup 8 .r ." ² = " sq . cr
    loop base ! ;

.squares
bye
