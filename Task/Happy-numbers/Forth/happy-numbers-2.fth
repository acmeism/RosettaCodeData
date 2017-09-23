CREATE HAPPINESS 0 C, 1 C, 0 C, 0 C, 0 C, 0 C, 0 C, 1 C, 0 C, 0 C,
: next ( n -- n')
   0 swap BEGIN dup WHILE 10 /mod >r  dup * +  r> REPEAT drop ;
: happy? ( n -- t|f)
   BEGIN dup 10 >= WHILE next REPEAT  chars HAPPINESS + C@ 0<> ;
: happy-numbers ( n --)  >r 0
   BEGIN r@ WHILE
     BEGIN 1+ dup happy? UNTIL dup . r> 1- >r
   REPEAT r> drop drop ;
8 happy-numbers
