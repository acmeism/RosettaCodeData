: first-last-three-equal { addr len -- ? }
  len 5 <= if false exit then
  addr 3 addr len 3 - + 3 compare 0= ;

256 constant max-line

: main
  0 0 { count fd-in }
  s" unixdict.txt" r/o open-file throw to fd-in
  begin
    here max-line fd-in read-line throw
  while
    here swap 2dup first-last-three-equal if
      count 1+ to count
      count 1 .r ." . " type cr
    else
      2drop
    then
  repeat
  drop
  fd-in close-file throw ;

main
bye
