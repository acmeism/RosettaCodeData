: bin. base @ 2 base ! swap u. base ! ;

: lwb ( n -- u )
  0 swap
  begin
  dup 1 and 0= while
    1 rshift
    swap 1+ swap
  repeat drop ;

: upb ( n -- u )
  -1 swap
  begin
  dup 0<> while
    1 rshift
    swap 1+ swap
  repeat drop ;

: Find_first_and_last_set_bit_of_a_long_integer
  1 6 0 do
    dup dup dup dup
    cr 10 .r ." : " ." MSB:" upb 2 .r ." , LSB:" lwb 2 .r ." , %" bin.
    42 *
  loop drop ;

Find_first_and_last_set_bit_of_a_long_integer
