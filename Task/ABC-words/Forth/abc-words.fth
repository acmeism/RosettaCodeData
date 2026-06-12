: abc-word? ( addr u -- ? )
  false false { a b }
  0 do
    dup c@ case
      'a' of true to a endof
      'b' of a invert if unloop drop false exit then true to b endof
      'c' of unloop drop b exit endof
    endcase
    1+
  loop
  drop
  false ;

256 constant max-line

: main
  0 0 { count fd-in }
  s" unixdict.txt" r/o open-file throw to fd-in
  begin
    here max-line fd-in read-line throw
  while
    here swap 2dup abc-word? if
      count 1+ to count
      count 2 .r ." : " type cr
    else
      2drop
    then
  repeat
  drop
  fd-in close-file throw ;

main
bye
