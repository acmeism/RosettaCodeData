: factorial ( u -- u )
  1 swap
  begin
    dup 0>
  while
    tuck * swap 1-
  repeat
  drop ;

: lah ( n k -- u )
  dup 1 = if drop factorial exit then
  dup 1 < if 2drop 0 exit then
  over 1 < if 2drop 0 exit then
  2dup = if 2drop 1 exit then
  2dup < if 2drop 0 exit then
  dup factorial over 1- factorial * >r
  swap dup factorial over 1- factorial *
  r> / >r swap - factorial r> swap / ;

: main ( -- )
  ." Unsigned Lah numbers L(n, k):" cr
  ." n/k"
  13 1 do
    i 11 .r
  loop cr
  13 1 do
    i 3 .r
    i 1+ 1 do
      j i lah 11 .r
    loop cr
  loop ;

main
bye
