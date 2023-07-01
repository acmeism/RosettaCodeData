\ data munging

\ 1991-03-30[\t10.000\t[-]1]*24

\ 1. mean of valid (flag > 0) values per day and overall
\ 2. length of longest run of invalid values, and when it happened

fvariable day-sum
variable day-n

fvariable total-sum
variable total-n

10 constant date-size    \ yyyy-mm-dd
create cur-date date-size allot

create bad-date date-size allot
variable bad-n

create worst-date date-size allot
variable worst-n

: split ( buf len char -- buf' l2  buf l1 )  \ where buf'[0] = char, l1 = len-l2
  >r 2dup r> scan
  2swap 2 pick - ;

: next-sample ( buf len -- buf' len' fvalue flag )
  #tab split >float   drop    1 /string
  #tab split snumber? drop >r 1 /string r> ;

: ok?  0> ;

: add-sample ( value -- )
  day-sum f@ f+ day-sum f!
  1 day-n +! ;

: add-day
  day-sum f@ total-sum f@ f+ total-sum f!
  day-n @ total-n +! ;

: add-bad-run
  bad-n @ 0= if
    cur-date bad-date date-size move
  then
  1 bad-n +! ;

: check-worst-run
  bad-n @ worst-n @ > if
    bad-n @ worst-n !
    bad-date worst-date date-size move
  then
  0 bad-n ! ;

: hour ( buf len -- buf' len' )
  next-sample ok? if
    add-sample
    check-worst-run
  else
    fdrop
    add-bad-run
  then ;

: .mean ( sum count -- ) 0 d>f f/ f. ;

: day ( line len -- )
  2dup + #tab swap c! 1+			\ append tab for parsing
  #tab split cur-date swap move 1 /string	\ skip date
  0e day-sum f!
  0  day-n !
  24 0 do hour loop 2drop
  cur-date date-size type ."  mean = "
  day-sum f@ day-n @ .mean cr
  add-day ;

stdin value input

: main
  s" input.txt" r/o open-file throw to input
  0e total-sum f!
  0 total-n !
  0 worst-n !
  begin  pad 512 input read-line throw
  while  pad swap day
  repeat
  input close-file throw
  worst-n @ if
    ."  Longest interruption: " worst-n @ .
    ." hours starting " worst-date date-size type cr
  then
  ."  Total mean = "
  total-sum f@ total-n @ .mean cr ;

main bye
