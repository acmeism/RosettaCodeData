variable prime-count

: prime-count-free ( -- )
  prime-count @ free abort" free failed"
  0 prime-count ! ;

: prime-count-allocate ( n -- )
  prime-count-free
  cells dup allocate abort" out of memory"
  tuck prime-count ! erase ;

: get-prime-count ( n -- n )
  cells prime-count @ + @ ;

: set-prime-count ( n1 n2 -- )
  cells prime-count @ + ! ;

: prime-count-init { n -- }
  n prime-count-allocate
  prime-count @ n cells +
  prime-count @ 2 cells +
  2dup > if 1 over ! then
  cell+
  begin
    2dup >
  while
    1 over !
    2 cells +
  repeat
  2drop
  3 begin
    dup dup * n <
  while
    dup get-prime-count 0<> if
      n over dup * do
        0 i set-prime-count
      dup 2* +loop
    then
    2 +
  repeat
  drop
  prime-count @ 0
  n 0 +do
    over @ + 2dup swap !
    swap cell+ swap
  loop
  2drop ;

: ceil ( r -- r )
  fnegate floor fnegate ;

: ramanujan-max ( n -- n )
  4 * s>f fdup fln f* ceil f>s ;

: ramanujan-prime { n -- n }
  n ramanujan-max
  begin
    dup 0 >=
  while
    dup get-prime-count
    over 2/ get-prime-count
    - n < if 1+ exit then
    1-
  repeat
  drop 0 ;

: main ( -- )
  1000000 ramanujan-max 1+ prime-count-init
  ." First 100 Ramanujan primes: " cr
  101 1 do
    i ramanujan-prime 4 .r
    i 10 mod 0= if cr else space then
  loop
  cr
  1000000 1000
  begin
    2dup >=
  while
    ." The " dup 1 .r ." th Ramanujan prime is "
    dup ramanujan-prime 1 .r ." ." cr
    10 *
  repeat
  2drop prime-count-free ;

main
bye
