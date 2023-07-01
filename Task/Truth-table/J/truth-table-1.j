truthTable=:3 :0
  assert. -. 1 e. 'data expr names table' e.&;: y
  names=. ~. (#~ _1 <: nc) ;:expr=. y
  data=. #:i.2^#names
  (names)=. |:data
  (' ',;:inv names,<expr),(1+#@>names,<expr)":data,.".expr
)
