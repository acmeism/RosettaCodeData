: sum ( i-xt lo hi term-xt -- r )
  \ stack effects: i-xt ( -- addr ); term-xt ( -- r1 )
  0e swap 1+ rot ?do ( r1 xt1 xt2 )
    i 2 pick execute ! dup execute f+
  loop 2drop ;

variable i1 \ avoid conflict with Forth word I
' i1 1 100 :noname 1e i1 @ s>f f/ ; sum f.
