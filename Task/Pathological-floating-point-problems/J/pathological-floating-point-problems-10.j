rump=:4 :0
  NB. enforce exact arithmetic
  add=. +&x:
  sub=. -&x:
  mul=. *&x:
  div=. %&x:

  a=. x
  a2=. a mul a

  b=. y
  b2=. b mul b
  b4=. b2 mul b2
  b6=. b2 mul b4
  b8=. b4 mul b4

  c333_75=. 1335 div 4 NB. 333.75
  term1=. c333_75 mul b6

  t11a2b2=. 11 mul a2 mul b2
  tnb6=. 0 sub b6
  tn121b4=. 0 sub 121 mul b4
  term2=. a2*(t11a2b2 + tnb6 + tn121b4 sub 2)

  c5_5=. 11 div 2 NB. 5.5
  term3=. c5_5 mul b8

  term4=. a div 2 mul b

  term1 add term2 add term3 add term4
)
