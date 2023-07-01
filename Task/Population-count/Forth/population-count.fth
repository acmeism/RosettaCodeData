: popcnt ( n -- u)  0 swap
   BEGIN dup WHILE tuck 1 AND +  swap 1 rshift REPEAT
   DROP ;
: odious? ( n -- t|f)  popcnt 1 AND ;
: evil? ( n -- t|f)  odious? 0= ;

CREATE A 30 ,
: task1   1 0  ." 3**i popcnt: "
   BEGIN dup A @ < WHILE
     over popcnt .  1+ swap 3 * swap
   REPEAT  DROP DROP CR ;
: task2   0 0  ." evil       : "
   BEGIN dup A @ < WHILE
     over evil? IF over . 1+ THEN swap 1+ swap
   REPEAT  DROP DROP CR ;
: task3   0 0  ." odious     : "
   BEGIN dup A @ < WHILE
     over odious? IF over . 1+ THEN swap 1+ swap
   REPEAT  DROP DROP CR ;
task1 task2 task3 BYE
