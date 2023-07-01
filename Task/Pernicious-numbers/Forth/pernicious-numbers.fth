: popcount { n -- u }
  0
  begin
    n 0<>
  while
    n n 1- and to n
    1+
  repeat ;

\ primality test for 0 <= n <= 63
: prime? ( n -- ? )
  1 swap lshift 0x28208a20a08a28ac and 0<> ;

: pernicious? ( n -- ? )
  popcount prime? ;

: first_n_pernicious_numbers { n -- }
  ." First " n . ." pernicious numbers:" cr
  1
  begin
    n 0 >
  while
    dup pernicious? if
      dup .
      n 1- to n
    then
    1+
  repeat
  drop cr ;

: pernicious_numbers_between { m n -- }
  ." Pernicious numbers between " m . ." and " n 1 .r ." :" cr
  n 1+ m do
    i pernicious? if i . then
  loop
  cr ;

25 first_n_pernicious_numbers
888888877 888888888 pernicious_numbers_between

bye
