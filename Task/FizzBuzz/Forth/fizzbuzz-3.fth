SYNONYM NOT INVERT \ Bitwise boolean not

: Fizz?  ( n -- ? )  3 MOD 0=  DUP IF ." Fizz" THEN ;
: Buzz?  ( n -- ? )  5 MOD 0=  DUP IF ." Buzz" THEN ;
: ?print  ( n ? -- )  IF . THEN ;
: FizzBuzz  ( -- )
   101 1 DO CR  I  DUP Fizz? OVER Buzz? OR  NOT ?print  LOOP ;

FizzBuzz
