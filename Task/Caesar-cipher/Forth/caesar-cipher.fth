: caesar ( c n -- c )
  over 32 or [char] a -
  dup 0 26 within if
    over + 25 > if 26 - then +
  else 2drop then ;

: caesar-string ( n str len -- )
  over + swap do i c@ over caesar i c! loop drop ;

: caesar-inverse ( n -- 'n ) 26 swap - 26 mod ;

2variable test
s" The five boxing wizards jump quickly!" test 2!

3 test 2@ caesar-string
test 2@ cr type

3 caesar-inverse test 2@ caesar-string
test 2@ cr type
