\ combsort for the Forth Newbie (GForth)

HEX
\ gratuitous variables ( Add clarity but NOT re-entrant)
VARIABLE GAP
VARIABLE SORTED      \ flag

DECIMAL
100 CONSTANT SIZE

\ allocate a small array of cells
CREATE Q   SIZE CELLS ALLOT

\ operator to index into the array
: ]Q  ( n -- adr) CELLS Q + ;

\ fill array and see array
: INITDATA ( -- )  SIZE 0 DO   SIZE I -  I ]Q !  LOOP ;

: SEEDATA  ( -- )  CR  SIZE 0 DO   I ]Q @ U.   LOOP ;

\ compute a new gap using scaled division
\ factored out for this example. Could be a macro or inline code.
: /1.3  ( n -- n' )    10 13 */ ;

\ factored out for this example. Could be a macro or inline code.
: XCHG  ( adr1 adr2 n1 n2-- ) SWAP ROT !  SWAP ! ;

: COMBSORT ( n -- )
    DUP >R                     \ copy n to return stack
    1+ GAP !                   \ set GAP to n+1
    BEGIN
      GAP @  /1.3  GAP !       \ re-compute the gap
      SORTED ON
      R@ GAP @ -  0            \ n-gap is loop limit
      DO
         I GAP @ + ]Q   I ]Q   \ compute array addresses
         OVER @ OVER @         \ fetch the data in each cell
         2DUP <                \ compare a copy of the data
         IF
            XCHG               \ Exchange the data in the cells
            SORTED OFF         \ flag we are not sorted
         ELSE
            2DROP 2DROP        \ remove address and data
         THEN
      LOOP
      SORTED @  GAP @ 0=  AND  \ test for complete
   UNTIL
   R> DROP ;                   \ remove 'n' from return stack
