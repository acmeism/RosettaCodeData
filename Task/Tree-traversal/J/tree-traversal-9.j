depth=: +/@((~: , (~: i.@#@{.)~) {:@,)@({~^:a:)

reorder=:4 :0
  'data parent'=. y
  data1=. x{data
  parent1=. x{data1 i. parent{data
  if. 0=L.y do. data1,:parent1 else. data1;parent1 end.
)

data=:3 :'data[''data parent''=. y'
parent=:3 :'parent[''data parent''=. y'

childinds=: [: <:@(2&{.@-.&> #\) (</. #\)`(]~.)`(a:"0)}~
