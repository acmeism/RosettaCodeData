maprange=:2 :0
  'a1 a2'=.m
  'b1 b2'=.n
  b1 + ((b2-b1)%a2-a1) * -&a1
)
NB. this version precomputes the scaling ratio
