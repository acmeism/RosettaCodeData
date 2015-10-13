\ Rosetta Code Knapp-sack 0-1 problem.  Tested under GForth 0.7.3.
\ 22 items. On current processors a set fits nicely in one CELL (32 or 64 bits).
\ Brute force approach: for every possible set of 22 items,
\ check for admissible solution then for optimal set.

: offs HERE over - ;
        400 VALUE WLIMIT
        0 VALUE ITEM
        0 VALUE VAL
        0 VALUE /ITEM
        0 VALUE ITEMS#
Create Sack
HERE
        9 ,                     offs TO VAL
        150 ,                   offs TO ITEM
        s" map            " s,  offs TO /ITEM
DROP
 13 ,  35 , s" compass        " s,
153 , 200 , s" water          " s,
 50 , 160 , s" sandwich       " s,
 15 ,  60 , s" glucose        " s,
 68 ,  45 , s" tin            " s,
 27 ,  60 , s" banana         " s,
 39 ,  40 , s" apple          " s,
 23 ,  30 , s" cheese         " s,
 52 ,  10 , s" beer           " s,
 11 ,  70 , s" suntan cream   " s,
 32 ,  30 , s" camera         " s,
 24 ,  15 , s" T-shirt        " s,
 48 ,  10 , s" trousers       " s,
 73 ,  40 , s" umbrella       " s,
 42 ,  70 , s" wp trousers    " s,
 43 ,  75 , s" wp overclothes " s,
 22 ,  80 , s" note-case      " s,
  7 ,  20 , s" sunglasses     " s,
 18 ,  12 , s" towel          " s,
  4 ,  50 , s" socks          " s,
 30 ,  10 , s" book           " s,
        HERE VALUE END-SACK
        VARIABLE Sol            \ Solution  Set
        VARIABLE Vmax           \ Temporary Maximum Value
        VARIABLE Sum            \ Temporary Sum (for speed-up)
: ]sum          ( Rtime: set -- sum  ;Ctime: hilimit.a start.a -- )
\ Loop unwinding & precomputing addresses
        ]
        ]] Sum OFF [[
        DO              ]] dup [[  1  ]] LITERAL AND IF [[  I  ]] LITERAL @ Sum +! THEN 2/ [[
        /ITEM +LOOP     ]] drop Sum @ [[
; IMMEDIATE
: solve         ( -- )
        Vmax OFF
        [ 1 END-SACK Sack - /ITEM / lshift 1- ]L 0
        DO
                I [ END-SACK Sack ]sum ( by weight ) WLIMIT <
                IF
                        I [ END-SACK VAL + Sack VAL + ]sum ( by value )
                        dup Vmax @ >
                        IF  Vmax ! I Sol !  ELSE  drop  THEN
                THEN
        LOOP
;
: .solution     ( -- )
        Sol @ END-SACK ITEM + Sack ITEM +
        DO
                dup 1 AND  IF  I count type cr  THEN
                2/
        /ITEM +LOOP
        drop
        ." Weight: " Sol @ [ END-SACK Sack ]sum .  ."  Value: " Sol @ [ END-SACK VAL + Sack VAL + ]sum .
;
