#! /usr/bin/gforth

\ Dice game probabilities

: min? ( addr -- min )
    @
;

: max? ( addr -- max )
    cell + @
;

: max+1-min? ( addr -- max+1 min )
    dup max? 1+ swap min?
;

: addr? ( addr x -- addr' )
    over min? - 2 + cells +
;

: weight? ( addr x -- w )
    2dup swap min? < IF
        2drop 0
    ELSE
        2dup swap max? > IF
            2drop 0
        ELSE
            addr? @
        THEN
    THEN
;

: total-weight?   ( addr -- w )
    dup max? 1+   ( addr max+1 )
    over min?     ( addr max+1 min )
    0 -rot ?DO ( adrr 0 max+1 min )
        over i weight? +
    LOOP
    nip
;

: uniform-aux ( min max x -- addr )
    >r 2dup
    2dup swap - 3 + cells allocate throw ( min max min max addr )
    tuck cell + !                        ( min max min addr )
    tuck !                               ( min max addr )
    -rot swap                            ( addr max min )
    r> -rot                              ( addr x max min )
    - 3 + 2 ?DO                          ( addr x )
        2dup swap i cells + !
    LOOP
    drop
;

: convolve { addr1 addr2 -- addr }
    addr1 min? addr2 min? +
    addr1 max? addr2 max? +
    0 uniform-aux                    { addr }
    addr1 max+1-min? ?DO
        addr2 max+1-min? ?DO
            addr1 j weight?
            addr2 i weight? *
            addr i j + addr? +!
        LOOP
    LOOP
    addr
;

: even? ( n -- f )
    2 mod 0=
;

: power ( addr exp -- addr' )
    dup 1 = IF
        drop
    ELSE
        dup even? IF
            2/ recurse dup convolve
        ELSE
            over swap 2/ recurse dup convolve convolve
        THEN
    THEN
;

: .dist { addr -- }
    addr total-weight? { tw }
    addr max+1-min? ?DO
        i 10 .r
        addr i weight? dup 20 .r
        0 d>f tw 0 d>f f/ ."  " f. cr
    LOOP
;

: dist-cmp { addr1 addr2 xt -- p }
    0
    addr1 max+1-min? ?DO
        addr2 max+1-min? ?DO
            j i xt execute IF
                addr1 j weight?
                addr2 i weight?
                * +
            THEN
        LOOP
    LOOP
    0 d>f
    addr1 total-weight? addr2 total-weight? um* d>f
    f/
;

: dist> ( addr1 addr2 -- p )
    ['] > dist-cmp
;

\ creates the uniform distribution with outcomes from min to max
: uniform ( min max -- addr )
    1 uniform-aux
;

\ example

1 4 uniform 9 power
1 6 uniform 6 power
dist> f. cr

1 10 uniform 5 power
1  7 uniform 6 power
dist> f. cr

bye
