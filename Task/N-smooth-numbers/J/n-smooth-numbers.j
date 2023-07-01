nsmooth=: dyad define  NB. TALLY nsmooth N
 factors=. x: i.@:>:&.:(p:inv) y
 smoothies=. , 1x
 result=. , i. 0x
 while. x > # result do.
  mn =. {. smoothies
  smoothies =. ({.~ (x <. #)) ~. /:~ (}. smoothies) , mn * factors
  result=. result , mn
 end.
)
