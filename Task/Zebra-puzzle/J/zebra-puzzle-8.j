Select=: [: ~. ,: #~ ,&(0~:#)
Filter=: #~ *./@:(2>#S:0)"1
Compose=: [: Filter [: ,/ Select L:0"1"1 _

solve=: 4 :0
h=. ,:x
whilst. 0=# z do.
  for_e. y do. h=. h Compose > e end.
  z=.(#~1=[:+/"1 (0=#)S:0"1) h=.~. h
end.
)
