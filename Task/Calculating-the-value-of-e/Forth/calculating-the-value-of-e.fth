100 constant #digits
: int-array  create cells allot  does> swap cells + ;

#digits 1+ int-array e-digits[]

: init-e ( -- )
   [ #digits 1+ ] literal 0 DO
      1  i e-digits[]  !
   LOOP
   ." = 2." ;

: .e  ( -- )
   init-e
   [ #digits 1- ] literal 0 DO
      0  \ carry
      0 #digits DO
         i e-digits[] dup @  10 *  rot +  i 2 + /mod -rot  swap !
      -1 +LOOP
      0 .r
   LOOP ;
