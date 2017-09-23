: happy-number ( n -- n')  \ produce the nth happy number
   >r 0  BEGIN r@ WHILE
     BEGIN 1+ dup happy? UNTIL  r> 1- >r
   REPEAT r> drop ;
1000000 happy-number .  \ 7105849
