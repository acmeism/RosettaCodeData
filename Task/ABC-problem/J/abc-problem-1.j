reduce=: verb define
  'rows cols'=. i.&.> $y
  for_c. cols do.
    r=. 1 i.~ c {"1 y             NB. row idx of first 1 in col
    if. r = #rows do. continue. end.
    y=. 0 (<((r+1)}.rows);c) } y  NB. zero rest of col
    y=. 0 (<(r;(c+1)}.cols)) } y  NB. zero rest of row
  end.
)

abc=: *./@(+./)@reduce@(e."1~ ,)&toupper :: 0:
