has=: 1 :'(0 {:: interval m)`:6'
ing=: `''

edge=: 1&{::&interval
edges=: /:~@~.@,&edge
contour=: (, 2 (+/%#)\ ])@edge

interval=: 3 :0
  if.0<L.y do.y return.end.
  assert. 5=#words=. ;:y
  assert. (0 { words) e. ;:'[('
  assert. (2 { words) e. ;:','
  assert. (4 { words) e. ;:'])'
  'lo hi'=.(1 3{0".L:0 words)
  'cL cH'=.0 4{words e.;:'[]'
  (lo&(<`<:@.cL) *. hi&(>`>:@.cH))ing ; lo,hi
)

union=: 4 :'(x has +. y has)ing; x edges y'
intersect=: 4 :'(x has *. y has)ing; x edges y'
without=: 4 :'(x has *. [: -. y has)ing; x edges y'
in=: 4 :'y has x'
isEmpty=: 1 -.@e. contour in ]
