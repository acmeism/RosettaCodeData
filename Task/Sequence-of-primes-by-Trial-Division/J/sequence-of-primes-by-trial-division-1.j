primTrial=:3 :0
  try=. i.&.(p:inv) %: >./ y
  candidate=. (y>1)*y=<.y
  y #~ candidate*(y e.try) = +/ 0= try|/ y
)
