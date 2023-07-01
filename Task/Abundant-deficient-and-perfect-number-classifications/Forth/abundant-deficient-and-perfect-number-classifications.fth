CREATE A 0 ,
: SLOT ( x y -- 0|1|2)  OVER OVER < -ROT > -  1+ ;
: CLASSIFY ( n -- n')  \ 0 == deficient, 1 == perfect, 2 == abundant
   DUP A !  \ we'll be accessing this often, so save somewhere convenient
   2 / >R   \ upper bound
   1        \ starting sum, 1 is always a divisor
   2        \ current check
   BEGIN DUP R@ < WHILE
     A @ OVER /MOD SWAP ( s c d m)
     IF DROP ELSE
       R> DROP DUP >R  ( R: d n)
       OVER TUCK OVER <> * -  ( s c c+?d)
       ROT + SWAP ( s' c)
     THEN 1+
   REPEAT  DROP R> DROP A @  ( sum n)  SLOT ;
CREATE COUNTS 0 , 0 , 0 ,
: INIT   COUNTS 3 CELLS ERASE  1 COUNTS ! ;
: CLASSIFY-NUMBERS ( n --)  INIT
   BEGIN DUP WHILE
     1 OVER CLASSIFY  CELLS COUNTS + +!  1-
   REPEAT  DROP ;
: .COUNTS
   ." Deficient : " [ COUNTS ]L           @ . CR
   ." Perfect   : " [ COUNTS 1 CELLS + ]L @ . CR
   ." Abundant  : " [ COUNTS 2 CELLS + ]L @ . CR ;
20000 CLASSIFY-NUMBERS .COUNTS BYE
