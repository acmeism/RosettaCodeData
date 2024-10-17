 combr1=: dyad define
  if.(x=#y) +. x=1 do.
    y
  else.
    (({.y) ,. (x-1) combr (}.y)) , (x combr }.y)
  end.
)
