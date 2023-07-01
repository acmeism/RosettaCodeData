: proper-divisors ( n -- 1..n )
  dup 2 / 1+ 1 ?do
    dup i mod 0= if i swap then
  loop drop ;

: divisors-sum ( 1..n -- n )
  dup 1 = if exit then
  begin over + swap
  1 = until ;

: pair ( n -- n )
  dup 1 = if exit then
  proper-divisors divisors-sum ;

: ?paired ( n -- t | f )
  dup pair 2dup pair
  = >r < r> and ;

: amicable-list
  1+ 1 do
    i ?paired if cr i . i pair . then
  loop ;

20000 amicable-list
