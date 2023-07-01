r2cf=:3 :0
  'n1 n2'=. y
  r=.''
  while.n2 do.
    'n1 t1 n2'=. n2,(0,n2)#:n1
    r=.r,t1
  end.
)
