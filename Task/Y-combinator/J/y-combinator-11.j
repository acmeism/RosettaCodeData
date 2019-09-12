Y=:1 :0
  f=. u Defer
  (5!:1<'f') f y
)

Defer=: 1 :0
:
  g=. x&(x`:6)
  (5!:1<'g') u y
)

almost_factorial=: 4 :0
  if. 0 >: y do. 1
  else. y * x`:6 y-1 end.
)

almost_fibonacci=: 4 :0
  if. 2 > y do. y
  else. (x`:6 y-1) + x`:6 y-2 end.
)
