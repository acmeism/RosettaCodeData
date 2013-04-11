comb1=: dyad define
  c=. 1 {.~ - d=. 1+y-x
  z=. i.1 0
  for_j. (d-1+y)+/&i.d do. z=. (c#j) ,. z{~;(-c){.&.>&lt;i.{.c=. +/\.c end.
)
