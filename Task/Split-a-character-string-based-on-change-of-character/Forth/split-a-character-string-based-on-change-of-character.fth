CREATE A 0 ,
: C@A+   A @ C@  [ 1 CHARS ]L A +! ;
: SPLIT. ( c-addr u --) SWAP A !  A @ C@
   BEGIN OVER WHILE
     C@A+  TUCK  <> IF ." , " THEN
     DUP EMIT  SWAP 1- SWAP
   REPEAT  DROP ;
: TEST   OVER OVER
   ." input: " TYPE CR
   ." split: " SPLIT. CR ;
s" gHHH5YY++///\"        TEST
s" gHHH5  ))YY++,,,///\" TEST
BYE
