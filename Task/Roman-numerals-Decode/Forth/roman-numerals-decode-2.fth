\ decode roman numerals using Forth methodology
\ create words to describe and solve the problem
\ ANS/ISO Forth

HEX
: TOUPPER ( char -- char ) 05F AND ;

DECIMAL
\ status holders
VARIABLE OLDNDX
VARIABLE CURNDX
VARIABLE NEGFLAG

: NUMERALS ( -- addr len)  S"  IVXLCDM" ;  ( 1st char is a blank)
CREATE VALUES ( -- addr) 0 , 1 , 5 , 10 , 50 , 100 , 500 , 1000 ,

: []  ( n addr -- addr[n]) SWAP CELLS +  ;  \ array address calc.

\ define words to describe/solve the problem
: INIT     ( -- )        CURNDX OFF  OLDNDX OFF  NEGFLAG OFF ;

: >INDEX  ( char -- ndx) TOUPPER >R  NUMERALS TUCK R> SCAN NIP -
                         DUP 7 > ABORT" Invalid Roman numeral" ;

: REMEMBER ( ndx -- ndx ) CURNDX @ OLDNDX !  DUP CURNDX !  ;

: ]VALUE@  ( ndx -- n )   REMEMBER VALUES [] @ ;

: >VALUE ( char -- n )   >INDEX ]VALUE@ ;

: ?ILLEGAL ( ndx --  )   CURNDX @ OLDNDX @ =  NEGFLAG @ AND ABORT" Illegal format" ;

\ LOGIC
: ?NEGATE ( n -- +n | -n)
           CURNDX @ OLDNDX @ <
           IF   NEGFLAG ON
                NEGATE
           ELSE
                ?ILLEGAL
                NEGFLAG OFF
           THEN ;

\ solution
: >ARABIC  ( addr len -- n )
           INIT
           0              \ accumulator on the stack
          -ROT 1- BOUNDS SWAP
           DO   I C@ >VALUE ?NEGATE +    -1 +LOOP ;
