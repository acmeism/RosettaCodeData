: vowel? ( c -- t/f )
  case
    'A' of true endof
    'E' of true endof
    'I' of true endof
    'O' of true endof
    'U' of true endof
    false swap
  endcase ;

: classify ( c -- n )
  toupper dup 'A' 'Z' 1+ within if
    vowel? if 1 else 2 then
  else
    drop 0
  then ;

: vowels-consonants ( addr u -- )
  ." string: '" 2dup type ." '" cr
  0 0 2swap
  0 ?do
    dup c@ classify
    case
      1 of swap 1+ swap endof
      2 of rot 1+ -rot endof
    endcase
    1+
  loop
  drop
  ." vowels: " . cr
  ." consonants: " . cr ;

S" Forever Forth programming language" vowels-consonants cr
S" Now is the time for all good men to come to the aid of their country." vowels-consonants
bye
