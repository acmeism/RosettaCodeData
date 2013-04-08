: .fizzbuzz ( n -- )
  0 pad c!
  dup 3 mod 0= if s" Fizz" pad  place then
  dup 5 mod 0= if s" Buzz" pad +place then
  pad c@ if drop pad count type else . then ;

: zz ( n -- )
  1+ 1 do i .fizzbuzz cr loop ;
100 zz
