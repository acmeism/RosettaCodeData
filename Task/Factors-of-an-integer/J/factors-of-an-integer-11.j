factorsOfNumber=: monad define
  Y=. y"_
  /:~ ~. ( , Y%]) ( #~ 0=]|Y) 1+i.>.%:y
)

   factorsOfNumber 40
1 2 4 5 8 10 20 40
