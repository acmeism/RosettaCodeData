: rep-string ( caddr1 u1 -- caddr2 u2 ) \ u2=0: not a rep-string
   2dup dup >r  r@ 2/ /string
   begin  2over 2over string-prefix? 0=  over r@ <  and  while  -1 /string  repeat
   r> swap - >r  2drop  r> ;

: test ( caddr u -- )
   2dup type ."  has "
   rep-string ?dup 0= if drop ." no " else type ."  as " then
   ." repeating substring" cr ;
: tests
   s" 1001110011" test
   s" 1110111011" test
   s" 0010010010" test
   s" 1010101010" test
   s" 1111111111" test
   s" 0100101101" test
   s" 0100100" test
   s" 101" test
   s" 11" test
   s" 00" test
   s" 1" test ;
