maprange=:2 :0
  'a1 a2'=.m
  'b1 b2'=.n
  b1+((y-a1)*b2-b1)%a2-a1
)
NB. this version defers all calculations to runtime, but mirrors exactly the task formulation
