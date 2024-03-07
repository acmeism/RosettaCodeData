\ Begin of approach. Depends on 'latestxt' word of GForth implementation.

: self-parameter  ( xt -- xt' )
  >r :noname  latestxt postpone literal r> compile, postpone ;
;
: Y  ( xt -- xt' )
  dup self-parameter 2>r
  :noname 2r> postpone literal compile, postpone ;
;
