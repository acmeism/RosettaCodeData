NB. indices are signed machine integers
vzero=: 1 $.2^31+IF64*32
odim=. 2^.#vzero

ndx01=:1 :0
:
  NB. indexed update of numeric rank 1 sparse y
  NB. creating rank 2 sparse result
  NB. using scalar values from x and scalar inds from m
  NB. where x, m are rank 0 or 1
  NB. (this works around a spurious error in sparse handling)
  n=. #x,.m
  x ((i.n),&.> m)} n#,:y
)

NB. specify that all axes are sparse, for better display
clean=: (2;i.@#@$) $. ]

gmul=:4 :0"1
  xj=. ,4$.x
  yj=. ,4$.y
  if. 0= xj *&# yj do. vzero return. end.
  b=. (-##:>./0,xj,yj)&{."1@#:
  xb=. b xj
  yb=. b yj
  rj=. ,#.xb~:"1/yb
  s=. ,_1^ ~:/"1 yb *"1/ 0,.}:"1 ~:/\"1 xb
  vzero (~.rj)}~ rj +//. s*,(xj{x)*/yj{y
)

gdot=: (gmul + gmul~) % 2:

obasis=:1 (2^i.odim)ndx01 vzero
e=: {&obasis
