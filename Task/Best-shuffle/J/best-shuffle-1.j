bestShuf =: verb define
  yy=. <@({~ ?~@#)@I.@= y
  y C.~ (;yy) </.~ (i.#y) |~ >./#@> yy
)

fmtBest=:3 :0
  b=. bestShuf y
  y,', ',b,' (',')',~":+/b=y
)
