has=: 1 :'(interval m)`:6'
ing=: `''

interval=: 3 :0
  if.0<L.y do.y return.end.
  assert. 5=#words=. ;:y
  assert. (0 { words) e. ;:'[('
  assert. (2 { words) e. ;:','
  assert. (4 { words) e. ;:'])'
  'lo hi'=.(1 3{0".L:0 words)
  'cL cH'=.0 4{words e.;:'[]'
  (lo&(<`<:@.cL) *. hi&(>`>:@.cH))ing
)

union=: 4 :'(x has +. y has)ing'
intersect=: 4 :'(x has *. y has)ing'
without=: 4 :'(x has *. [: -. y has)ing'
