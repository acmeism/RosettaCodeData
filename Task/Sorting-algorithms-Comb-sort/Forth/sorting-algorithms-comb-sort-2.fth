\ combsort for the Forth Newbie (GForth)
HEX
\ gratuitous variables for clarity
0 VALUE  GAP
VARIABLE SORTED

DECIMAL
100 CONSTANT SIZE

\ allocate a small array of cells
CREATE Q   SIZE 2+  CELLS ALLOT

\ operator to index into the array
: ]Q  ( n -- adr) CELLS Q + ;

\ fill array and see array
: INITDATA ( -- )      SIZE 0 DO  SIZE I -  I ]Q !  LOOP ;
: SEEDATA  ( -- )  CR  SIZE 0 DO  I ]Q @ U.   LOOP ;

\ divide by 1.35 using Forth's scaling operator
\ found this ratio to be the fastest
: 1.35/  ( n -- n' ) 100 135 */ ;

: XCHG  ( adr1 adr2 -- ) OVER @ OVER @ SWAP ROT !  SWAP ! ;

: COMBSORT ( n -- )
    DUP  TO GAP                      \ set GAP to n
    BEGIN
      GAP 1.35/  TO GAP              \ re-compute the gap
      SORTED ON
      DUP ( -- n) GAP -  0           \ n-gap is loop limit
      DO
         I GAP + ]Q @  I ]Q @ <
         IF
            I GAP + ]Q  I ]Q XCHG    \ Exchange the data in the cells
            SORTED OFF               \ flag we are not sorted
         THEN
      LOOP
      SORTED @  GAP 0=  AND          \ test for complete
   UNTIL
   DROP
;
