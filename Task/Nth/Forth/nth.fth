: 'nth ( -- c-addr )  s" th st nd rd th th th th th th " drop ;
: .nth ( n -- )
  dup 100 mod 10 20 within if 0 .r ." th " exit then
  dup 0 .r 10 mod 3 * 'nth + 3 type ;

: test ( n n -- )  cr do i 5 mod 0= if cr then i .nth loop ;
: tests ( -- )
  26 0 test  266 250 test  1026 1000 test ;

tests
