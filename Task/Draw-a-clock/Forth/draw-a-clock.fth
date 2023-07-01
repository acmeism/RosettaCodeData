HEX
8379 CONSTANT TICKER   \ address of 1/60 second counter

CREATE PDT ( -- addr) \ bit pattern descriptors for 0..9 and colon
        0038 , 444C , 5464 , 4438 , ( 0)
        0010 , 3010 , 1010 , 1038 , ( 1)
        0038 , 4404 , 1820 , 407C , ( 2)
        007C , 0810 , 0804 , 4438 , ( 3)
        0008 , 1828 , 487C , 0808 , ( 4)
        007C , 4078 , 0404 , 4438 , ( 5)
        0038 , 4040 , 7844 , 4438 , ( 6)
        007C , 0408 , 1020 , 2020 , ( 7)
        0038 , 4444 , 3844 , 4438 , ( 8)
        0038 , 4444 , 3C04 , 0438 , ( 9)
        0000 , 3030 , 0030 , 3000 , ( :)

: ]PDT  ( 0..9 -- addr) [CHAR] 0 - 8 * PDT + ;

: BIG.TYPE ( caddr len -- )
    8 0
    DO
        CR
        2DUP BOUNDS
        ?DO
            I C@ ]PDT J + C@         \ PDT char, byte# J
            2 7 DO                   \ from bit# 7 to 2
                DUP 1 I LSHIFT AND   \ mask out each bit
                IF    [char] * EMIT  \ if true emit a character
                ELSE  SPACE          \ else print space
                THEN
            -1 +LOOP  DROP
        LOOP
    LOOP
    2DROP ;

DECIMAL

CREATE SECONDS  0 , 0 ,   \ 2 CELLS, holds a double integer

: SECONDS++  ( -- )  SECONDS 2@ 1 M+  SECONDS 2! ;

\  subtract old value from new value until ticker changes.
: 1/60  ( -- )
        TICKER DUP @  ( -- addr value)
        BEGIN
             PAUSE    \ *Gives time to other Forth processes while we wait
             OVER @   \ read ticker addr
             OVER -   \ subtract from old value
        UNTIL
        2DROP ;

: SEXTAL ( -- ) 6 BASE ! ;
: 1SEC   ( -- ) 60 0 DO  1/60  LOOP   SECONDS++  ;
: ##:    ( -- ) # SEXTAL # DECIMAL [CHAR] : HOLD  ;
: .TIME  ( d --) <#  ##: ##: # # #> BIG.TYPE ;

: CLOCK  ( -- )
         DECIMAL  \ set task's local radix
         BEGIN
            1SEC
            0 0 AT-XY  SECONDS 2@ .TIME
            ?TERMINAL
         UNTIL
         2DROP ;
