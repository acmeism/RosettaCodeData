mp=: +/ . *  NB. matrix product
h =: +@|:    NB. conjugate transpose

cholesky=: 3 : 0
 n=. #A=. y
 if. 1>:n do.
  assert. (A=|A)>0=A  NB. check for positive definite
  %:A
 else.
  p=. >.n%2 [ q=. <.n%2
  X=. (p,p) {.A [ Y=. (p,-q){.A [ Z=. (-q,q){.A
  L0=. cholesky X
  L1=. cholesky Z-(T=.(h Y) mp %.X) mp Y
  L0,(T mp L0),.L1
 end.
)
