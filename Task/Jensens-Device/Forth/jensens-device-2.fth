fvariable ii \ i is a Forth word that we need
: sum ( xt1 lo hi xt2 -- r )
  0e swap 1+ rot ?do ( addr xt r1 )
    i s>f over execute f! dup execute f+
  loop 2drop ;
' ii 1 100 :noname 1e ii f@ f/ ; sum f.
