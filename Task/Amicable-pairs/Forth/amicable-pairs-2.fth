variable amicable-table

: proper-divisors ( n -- 1..n )
  dup 1 = if exit then ( not really but useful )
  dup 2 / 1+ 1 ?do
    dup i mod 0= if i swap then
  loop drop ;

: divisors-sum ( 1..n -- n )
  dup 1 = if exit then
  begin over + swap
  1 = until ;

: build-amicable-table
  here amicable-table !
  1+ dup ,
  1 do
    i proper-divisors divisors-sum ,
  loop ;

: paired cells amicable-table @ + @ ;

: .amicables
  amicable-table @ @ 1 do
    i paired paired i =
    i paired i > and
    if cr i . i paired . then
  loop ;

: amicable-list
  build-amicable-table .amicables ;

20000 amicable-list
