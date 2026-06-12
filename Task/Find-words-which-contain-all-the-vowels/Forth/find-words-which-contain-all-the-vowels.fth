: contains-all-vowels-once ( addr u -- ? )
  0 { vowels }
  0 do
    dup c@ case
      'a' of  1 endof
      'e' of  2 endof
      'i' of  4 endof
      'o' of  8 endof
      'u' of 16 endof
      0 swap
    endcase
    dup 0<> if
      vowels or
      dup vowels = if
        unloop 2drop false exit
      then
      to vowels
    else
      drop
    then
    1+
  loop
  drop
  vowels 31 = ;

256 constant max-line
create line-buffer max-line 2 + allot

: main
  0 0 { count fd-in }
  s" unixdict.txt" r/o open-file throw to fd-in
  begin
    line-buffer max-line fd-in read-line throw
  while
    dup 10 > if
      line-buffer swap 2dup contains-all-vowels-once if
        count 1+ to count
        count 2 .r ." . " type cr
      else
        2drop
      then
    else
      drop
    then
  repeat
  drop
  fd-in close-file throw ;

main
bye
