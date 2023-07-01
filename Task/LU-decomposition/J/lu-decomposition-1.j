mp=: +/ .*

LU=: 3 : 0
  'm n'=. $ A=. y
  if. 1=m do.
    p ; (=1) ; p{"1 A [ p=. C. (n-1);~.0,(0~:,A)i.1
  else.
    m2=. >.m%2
    'p1 L1 U1'=. LU m2{.A
    D=. (/:p1) {"1 m2}.A
    F=. m2 {."1 D
    E=. m2 {."1 U1
    FE1=. F mp %. E
    G=. m2}."1 D - FE1 mp U1
    'p2 L2 U2'=. LU G
    p3=. (i.m2),m2+p2
    H=. (/:p3) {"1 U1
    (p1{p3) ; (L1,FE1,.L2) ; H,(-n){."1 U2
  end.
)

permtomat=: 1 {.~"0 -@>:@:/:
LUdecompose=: (permtomat&.>@{. , }.)@:LU
