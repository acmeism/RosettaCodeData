#! /usr/bin/gforth

\ Ascending primes

\ checks (by simple trial-division) whether the TOS is prime
: prime? ( n -- f )
    dup 1 <= IF
        drop false
    ELSE
        dup 2 = IF
            drop true
        ELSE
            2
            BEGIN
                2dup dup * > >r
                2dup mod 0> r>
                over and
            WHILE
                drop 1+
            REPEAT
            nip nip
        THEN
    THEN
;

: ascending-primes-aux ( n i -- )
    dup 10 = IF
        drop
        dup prime? IF
            .
        ELSE
            drop
        THEN
    ELSE
        2dup 1+ recurse                  \ do not include digit i
        swap 10 * over + swap 1+ recurse \ do include digit i
    THEN
;

\ prints all primes with strictly ascending digits
: ascending-primes ( -- )
    0 1 ascending-primes-aux cr
;

ascending-primes bye
