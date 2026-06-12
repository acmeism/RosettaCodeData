CREATE A CELL ALLOT
: A[] ( n -- A[n]) CELLS A @ + @ ;
:NONAME   1- ;
:NONAME   R> DROP R> DROP TRUE ;
:NONAME   SWAP 1+ SWAP ;
CREATE VTABLE , , ,
: CMP ( n n' -- -1|0|1)  - DUP IF DUP ABS / THEN ;
: (TWOSUM) ( addr n n' -- u1 u2 t | f)
   >R SWAP A !  0 SWAP 1-  ( lo hi) ( R: n')
   BEGIN OVER OVER < WHILE
     OVER A[]  OVER A[]  + R@
     CMP  1+ CELLS VTABLE + @ EXECUTE
   REPEAT
   DROP DROP R> DROP FALSE ;
: TWOSUM ( addr n n' --)  [CHAR] [ EMIT
   (TWOSUM) IF SWAP 0 .R [CHAR] , EMIT SPACE 0 .R THEN
   [CHAR] ] EMIT ;
CREATE TEST0  0 ,  2 , 11 , 19 , 90 ,            DOES> 5 ;
CREATE TEST1 -8 , -2 ,  0 ,  1 ,  5 ,  8 , 11 ,  DOES> 7 ;
TEST0 21 TWOSUM CR
TEST0 25 TWOSUM CR
TEST1 3  TWOSUM CR
TEST1 8  TWOSUM CR
BYE
