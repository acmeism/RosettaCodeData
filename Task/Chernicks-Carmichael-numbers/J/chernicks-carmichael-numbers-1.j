a=: {{)v
  if.3=y do.1729 return.end.
  m=. z=. 2^y-4
  f=. 6 12,9*2^}.i.y-1
  while.do.
    uf=.1+f*m
    if.*/1 p: uf do. */x:uf return.end.
    m=.m+z
  end.
}}
