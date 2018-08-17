100000 CONSTANT SIZE

CREATE MYARRAY   SIZE CELLS ALLOT

: []   ( n addr -- addr[n])  SWAP CELLS + ;

: FILLIT ( -- ) ( reversed order)
  SIZE 0  DO   SIZE I -   I MYARRAY [] !  LOOP ;

: SEEIT  ( -- )
  SIZE 0 DO  I MYARRAY [] ?   LOOP ;

\ define non-standard words used by Quicksort author
1 CELLS CONSTANT CELL
CELL NEGATE CONSTANT -CELL
: CELL-   CELL - ;

: MID ( l r -- mid ) OVER - 2/ -CELL AND + ;

: EXCH    ( addr1 addr2 -- )
  OVER @ OVER @        ( read values)
  SWAP ROT ! SWAP ! ;  ( exchange values)

: PARTITION ( l r -- l r r2 l2 )
  2DUP MID @ >R ( r: pivot )
  2DUP
  BEGIN
    SWAP BEGIN  DUP @  R@  < WHILE CELL+ REPEAT
    SWAP BEGIN  R@ OVER @  < WHILE CELL- REPEAT
    2DUP <= IF 2DUP EXCH  >R CELL+ R> CELL-  THEN
    2DUP >
  UNTIL
  R> DROP ;

: QSORT ( l r -- )
  PARTITION  SWAP ROT
  2DUP < IF RECURSE ELSE 2DROP THEN
  2DUP < IF RECURSE ELSE 2DROP THEN ;

: QUICKSORT ( array len -- )
  DUP 2 < IF 2DROP EXIT THEN  1- CELLS OVER + QSORT ;
