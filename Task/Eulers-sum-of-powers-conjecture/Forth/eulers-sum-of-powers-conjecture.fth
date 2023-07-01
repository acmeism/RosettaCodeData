: sq  dup * ;
: 5^  dup sq sq * ;

create pow5 250 cells allot
:noname
   250 0 DO  i 5^  pow5 i cells + !  LOOP ; execute

: @5^  cells pow5 + @ ;

: solution? ( n -- n )
   pow5 250 cells bounds DO
      dup i @ = IF  drop i pow5 - cell / unloop EXIT  THEN
   cell +LOOP drop 0 ;

\ GFORTH only provides 2 index variables: i, j
\ so the code creates locals for two outer loop vars, k & l

: euler  ( -- )
   250 4 DO i { l }
      l 3 DO i { k }
         k 2 DO
            i 1 DO
               i @5^ j @5^ + k @5^ + l @5^ + solution?
               dup IF
                  l . k . j . i . . cr
                  unloop unloop unloop unloop EXIT
               ELSE
                  drop
               THEN
            LOOP
         LOOP
      LOOP
   LOOP ;

euler
bye
