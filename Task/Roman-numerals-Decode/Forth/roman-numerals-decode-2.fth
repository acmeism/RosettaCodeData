\ decode roman numerals using Forth methodology
\ create words to describe and solve the problem
\ ANS/ISO Forth

\ state holders
VARIABLE OLDNDX
VARIABLE CURNDX
VARIABLE NEGFLAG

DECIMAL
CREATE VALUES ( -- addr) 0 , 1 , 5 , 10 , 50 , 100 , 500 , 1000 ,

: NUMERALS ( -- addr len)  S"  IVXLCDM" ;        \ 1st char is a blank
: []       ( n addr -- addr') SWAP CELLS +  ;    \ array address calc.
: INIT     ( -- )         CURNDX OFF  OLDNDX OFF  NEGFLAG OFF ;
: REMEMBER ( ndx -- ndx ) CURNDX @ OLDNDX !  DUP CURNDX !  ;
: ]VALUE@  ( ndx -- n )   REMEMBER VALUES [] @ ;
HEX
: TOUPPER ( char -- char ) 05F AND ;

DECIMAL
: >INDEX   ( char -- ndx) TOUPPER >R  NUMERALS TUCK R> SCAN NIP -
                          DUP 7 > ABORT" Invalid Roman numeral" ;

: >VALUE   ( char -- n ) >INDEX ]VALUE@ ;
: ?ILLEGAL ( ndx --  )   CURNDX @ OLDNDX @ =  NEGFLAG @ AND ABORT" Illegal format" ;

: ?NEGATE ( n -- +n | -n) \ conditional NEGATE
           CURNDX @ OLDNDX @ <
           IF   NEGFLAG ON  NEGATE
           ELSE ?ILLEGAL  NEGFLAG OFF
           THEN ;

: >ARABIC  ( addr len -- n )
           INIT
           0  -ROT            \ accumulator under the stack string args
           1- BOUNDS          \ convert addr len to two addresses
           SWAP DO            \ index the string from back to front
                  I C@ >VALUE ?NEGATE +
          -1 +LOOP ;
