: e3 ( addr u -- ? )
  0 { ecount }
  0 do
    dup c@ case
      'a' of false endof
      'e' of ecount 1+ to ecount true endof
      'i' of false endof
      'o' of false endof
      'u' of false endof
      true swap
    endcase
    invert if unloop drop false exit then
    1+
  loop
  drop
  ecount 3 > ;

256 constant max-line

: main
  0 0 { count fd-in }
  s" unixdict.txt" r/o open-file throw to fd-in
  begin
    here max-line fd-in read-line throw
  while
    here swap 2dup e3 if
      count 1+ to count
      count 2 .r ." . " type cr
    else
      2drop
    then
  repeat
  drop
  fd-in close-file throw ;

main
bye
