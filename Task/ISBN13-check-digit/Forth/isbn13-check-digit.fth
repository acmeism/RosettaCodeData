: is-digit [char] 0 - 10 u< ;

: isbn?                                ( a n -- f)
  1- chars over + 2>r 0 1 2r> ?do
    dup i c@ dup is-digit              \ get length and factor, setup loop
    if [char] 0 - * rot + swap 3 * 8 mod else drop drop then
  -1 chars +loop drop 10 mod 0=        \ now calculate checksum
;
