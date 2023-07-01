mp=: +/ . *  NB. matrix product
h =: +@|:    NB. conjugate transpose

cholesky=: 3 : 0
 n=. #A=. y
 if. 1>:n do.
  assert. (A=|A)>0=A  NB. check for positive definite
  %:A
 else.
  'X Y t Z'=. , (;~n$(>.-:n){.1) <;.1 A
  L0=. cholesky X
  L1=. cholesky Z-(T=.(h Y) mp %.X) mp Y
  L0,(T mp L0),.L1
 end.
)
