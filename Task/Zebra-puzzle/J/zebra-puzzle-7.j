select=: ~.@(,: #~ ,&(0~:#))
filter=: #~*./@:(2>#S:0)"1
compose=: [: filter f. [: ,/ select f. L:0"1"1 _

solve=: 4 :0
h=. ,:x
whilst. 0=# z do.
  for_e. y do. h=. h compose > e end.
  z=.(#~1=[:+/"1 (0=#)S:0"1) h=.~. h
end.
)
