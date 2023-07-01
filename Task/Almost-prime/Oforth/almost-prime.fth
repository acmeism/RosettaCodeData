: kprime?( n k -- b )
| i |
   0 2 n for: i [
      while( n i /mod swap 0 = ) [ ->n 1+ ] drop
      ]
   k ==
;

: table( k -- [] )
| l |
   Array new dup ->l
   2 while (l size 10 <>) [ dup k kprime? if dup l add then 1+ ]
   drop
;
