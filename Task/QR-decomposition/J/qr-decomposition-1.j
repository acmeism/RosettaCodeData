mp=: +/ . *  NB. matrix product
h =: +@|:    NB. conjugate transpose

QR=: 3 : 0
 n=.{:$A=.y
 if. 1>:n do.
  A ((% {.@,) ; ]) %:(h A) mp A
 else.
  m =.>.n%2
  A0=.m{."1 A
  A1=.m}."1 A
  'Q0 R0'=.QR A0
  'Q1 R1'=.QR A1 - Q0 mp T=.(h Q0) mp A1
  (Q0,.Q1);(R0,.T),(-n){."1 R1
 end.
)
