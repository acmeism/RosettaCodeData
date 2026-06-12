\ tests whether n is prime for 0 <= n < 10
: prime? ( n -- ? )
  1 swap lshift 0xac and 0<> ;

: strange? ( n -- ? )
  dup 10 < if drop false exit then
  10 /mod swap >r
  begin
    dup 0 >
  while
    10 /mod swap
    dup r> - abs
    prime? invert if 2drop false exit then
    >r
  repeat
  drop rdrop true ;

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
