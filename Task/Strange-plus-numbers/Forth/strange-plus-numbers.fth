create isprime false , false , true , true , false ,
 true , false , true , false , false , false , true ,
 false , true , false , false , false , true , false ,

\ tests whether n is prime for 0 <= n < 19
: prime? ( n -- ? )
  cells isprime + @ ;

: strange? ( n -- ? )
  dup 10 < if drop false exit then
  begin
    dup 10 >=
  while
    dup 10 /mod 10 mod +
    prime? invert if drop false exit then
    10 /
  repeat
  drop true ;

: main
  0
  500 101 do
    i strange? if
      i .
      1+
      dup 10 mod 0= if cr then else
    then
  loop
  cr
  drop ;

main
bye
