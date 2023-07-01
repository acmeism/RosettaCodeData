jensen=: monad define
  'name lo hi expression'=. y
  temp=. 0
  for_n. lo+i.1+hi-lo do.
    (name)=. n
    temp=. temp + ".expression
  end.
)
