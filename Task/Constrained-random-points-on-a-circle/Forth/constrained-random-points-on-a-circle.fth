#! /usr/bin/gforth
\ Constrained random points on a circle

require random.fs

\ initialize the random number generator with a time-dependent seed
utime drop seed !

\ generates a random integer in [-15,15]
: random-coord ( -- n )
    31 random 15 -
;

\ generates a random point on the constrained circle
: random-point ( -- x y )
    0 0
    BEGIN
        2drop
        random-coord random-coord
        2dup dup * swap dup * +
        dup 100 >= swap 225 <= and
    UNTIL
;

31 31 * CONSTANT SIZE
CREATE GRID SIZE cells allot GRID SIZE cells erase

\ get the address of point (x,y)
: point-addr ( x y -- addr )
    15 + 31 * + 15 + cells GRID +
;

\ generate 100 random points and mark them in the grid
: gen-points ( -- )
    100 0 ?DO
        true random-point point-addr !
    LOOP
;

\ prints the grid
: print-grid ( -- )
    16 -15 ?DO
        16 -15 ?DO
            i j point-addr @
            IF
                42
            ELSE
                32
            THEN
            emit
        LOOP
        cr
    LOOP
;

gen-points print-grid
bye
