: vowel? ( c -- ? )
  case
    'a' of true endof
    'e' of true endof
    'i' of true endof
    'o' of true endof
    'u' of true endof
    0 swap
  endcase ;

: alternating-vowels-and-consonants { addr len -- ? }
  len 9 <= if false exit then
  len 1 do
    addr i + c@ vowel? addr i 1- + c@ vowel? = if
      unloop false exit
    then
  loop true ;

256 constant max-line

: main
  0 0 { count fd-in }
  s" unixdict.txt" r/o open-file throw to fd-in
  begin
    here max-line fd-in read-line throw
  while
    here swap 2dup alternating-vowels-and-consonants if
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
