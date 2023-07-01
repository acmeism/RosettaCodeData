#! /usr/bin/gforth

\ Elementary cellular automaton

\ checks if bit ix (where 0 is the least significant one) of u is set
: bit? ( u ix -- f )
    1 over lshift rot and swap rshift 1 =
;

\ displays a bit-array with n bits starting at address addr
: .arr ( addr n -- )
    0 DO
        dup @ IF 1 ELSE 0 THEN .
        cell +
    LOOP
    drop
;

\ applies rule r to the bit-array with n bits starting at address addr
: generation { r addr n -- }
    addr n 1- cells + @      IF 2 ELSE 0 THEN
    addr              @ tuck IF 1 ELSE 0 THEN
    +
    n 0 ?DO
        i n 1- = IF swap ELSE addr i 1+ cells + @ THEN
        IF 1 ELSE 0 THEN
        swap 1 lshift +
        r over bit?
        addr i cells + !
        3 and
    LOOP
    drop
;

\ evolves a rule over several generations
: evolve { r addr n m -- }
    ." P1" cr
    n . m . cr
    addr n .arr cr
    m 1- 0 ?DO
        r addr n generation
        addr n .arr cr
    LOOP
;

\ evolves a rule over several generations and saves the result as a pbm-image
\ and writes the result to file c-addr u
: evolve-pbm ( r addr n m c-addr u -- )
    w/o create-file throw dup 2>r
    ['] evolve r> outfile-execute
    r> close-file throw
;

CREATE arr 1000 cells allot

arr 1000 cells erase
true arr 500 cells + !
30 arr 1000 2000 s" rule-030.pbm" evolve-pbm

arr 1000 cells erase
true arr 500 cells + !
60 arr 1000 2000 s" rule-060.pbm" evolve-pbm

arr 1000 cells erase
true arr 500 cells + !
90 arr 1000 2000 s" rule-090.pbm" evolve-pbm

arr 1000 cells erase
true arr 500 cells + !
110 arr 1000 2000 s" rule-110.pbm" evolve-pbm

bye
