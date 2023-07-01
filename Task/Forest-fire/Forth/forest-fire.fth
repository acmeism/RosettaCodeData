30             CONSTANT WIDTH
30             CONSTANT HEIGHT
WIDTH HEIGHT * CONSTANT SIZE

1 VALUE SEED
: (RAND) ( -- u)  \ xorshift generator
   SEED DUP 13 LSHIFT XOR
        DUP 17 RSHIFT XOR
        DUP  5 LSHIFT XOR
        DUP TO SEED ;
10000 CONSTANT RANGE
100   CONSTANT GROW
1     CONSTANT BURN
: RAND ( -- u)  (RAND) RANGE MOD ;

\ Create buffers for world state
CREATE A  SIZE ALLOT  A SIZE ERASE
CREATE B  SIZE ALLOT  B SIZE ERASE

0 CONSTANT NONE  1 CONSTANT TREE  2 CONSTANT FIRE
: NEARBY-FIRE? ( addr u -- t|f)
   2 -1 DO
     2 -1 DO
       J WIDTH * I + OVER +  \ calculate an offset
       DUP 0> OVER SIZE < AND IF
         >R OVER R> + C@     \ fetch state of the offset cell
         FIRE = IF UNLOOP UNLOOP DROP DROP TRUE EXIT THEN
       ELSE DROP THEN
     LOOP
   LOOP  DROP DROP FALSE ;
: GROW?   RAND GROW <= ;  \ spontaneously sprout?
: BURN?   RAND BURN <= ;  \ spontaneously combust?
: STEP ( prev next --)  \ Given state in PREV, put next in NEXT
   >R 0 BEGIN DUP SIZE <
   WHILE
      2DUP + C@ CASE
      FIRE OF NONE ENDOF
      TREE OF 2DUP NEARBY-FIRE? BURN? OR IF FIRE ELSE TREE THEN ENDOF
      NONE OF GROW? IF TREE ELSE NONE THEN ENDOF
      ENDCASE
      ( i next-cell-state) OVER R@ + C!        \ commit to next
   1+ REPEAT  R> DROP DROP DROP ;

: (ESCAPE)   27 EMIT [CHAR] [ EMIT ;
: ESCAPE"   POSTPONE (ESCAPE) POSTPONE S" POSTPONE TYPE ;  IMMEDIATE
: CLEAR   ESCAPE" H" ;
: RETURN   ESCAPE" E" ;
: RESET   ESCAPE" m" ;
: .FOREST ( addr --)  CLEAR
   HEIGHT 0 DO
     WIDTH 0 DO
       DUP C@ CASE
       NONE OF SPACE ENDOF
       TREE OF ESCAPE" 32m" [CHAR] T EMIT RESET ENDOF
       FIRE OF ESCAPE" 31m" [CHAR] # EMIT RESET ENDOF
       ENDCASE  1+
     LOOP  RETURN
   LOOP RESET DROP ;

: (GO) ( buffer buffer' -- buffer' buffer)
   2DUP STEP    \ step the simulation
   DUP .FOREST  \ print the current state
   SWAP ;       \ prepare for next iteration
: GO   A B  BEGIN (GO) AGAIN ;
