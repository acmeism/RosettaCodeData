coclass 'priorityQueue'

PRI=: ''
QUE=: ''

insert=:4 :0
  p=. PRI,x
  q=. QUE,y
  assert. p -:&$ q
  assert. 1 = #$q
  ord=: \: p
  QUE=: ord { q
  PRI=: ord { p
  i.0 0
)

topN=:3 :0
  assert y<:#PRI
  r=. y{.QUE
  PRI=: y}.PRI
  QUE=: y}.QUE
  r
)
