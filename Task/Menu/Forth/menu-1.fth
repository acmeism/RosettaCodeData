\ Rosetta Code Menu Idiomatic Forth

\ vector table compiler
: CASE:  ( -- ) CREATE ;
: |      ( -- <text>)  '  ,  ;  IMMEDIATE
: ;CASE  ( -- ) DOES>  SWAP CELLS + @ EXECUTE ;

: NIL      ( -- addr len) S" " ;
: FEE      ( -- addr len) S" fee fie" ;
: HUFF     ( -- addr len) S" huff and puff" ;
: MIRROR   ( -- addr len) S" mirror mirror" ;
: TICKTOCK ( -- addr len) S" tick tock" ;

CASE: SELECT ( n -- addr len)
     | NIL | FEE | HUFF | MIRROR | TICKTOCK
;CASE

CHAR 1 CONSTANT '1'
CHAR 4 CONSTANT '4'
: BETWEEN ( n low hi -- ?)  1+ WITHIN ;

: MENU ( addr len -- addr len )
       DUP 0=
       IF
          2DROP  NIL  EXIT
       ELSE
          BEGIN
             CR
             CR 2DUP 3 SPACES   TYPE
             CR   ." 1 " 1 SELECT TYPE
             CR   ." 2 " 2 SELECT TYPE
             CR   ." 3 " 3 SELECT TYPE
             CR   ." 4 " 4 SELECT TYPE
             CR ." Choice: " KEY DUP EMIT
             DUP '1' '4' BETWEEN 0=
          WHILE
              DROP
          REPEAT
          -ROT 2DROP    \ drop input string
          CR [CHAR] 0 -  SELECT
       THEN
;
