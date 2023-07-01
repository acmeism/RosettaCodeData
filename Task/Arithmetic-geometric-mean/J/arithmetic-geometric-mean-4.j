DP=:101

round=: DP&$: : (4 : 0)
 b %~ <.1r2+y*b=. 10x^x
)

sqrt=: DP&$: : (4 : 0) " 0
 assert. 0<:y
 %/ <.@%: (2 x: (2*x) round y)*10x^2*x+0>.>.10^.y
)

ln=: DP&$: : (4 : 0) " 0
 assert. 0<y
 m=. <.0.5+2^.y
 t=. (<:%>:) (x:!.0 y)%2x^m
 if. x<-:#":t do. t=. (1+x) round t end.
 ln2=. 2*+/1r3 (^%]) 1+2*i.>.0.5*(%3)^.0.5*0.1^x+>.10^.1>.m
 lnr=. 2*+/t   (^%]) 1+2*i.>.0.5*(|t)^.0.5*0.1^x
 lnr + m * ln2
)

exp=: DP&$: : (4 : 0) " 0
 m=. <.0.5+y%^.2
 xm=. x+>.m*10^.2
 d=. (x:!.0 y)-m*xm ln 2
 if. xm<-:#":d do. d=. xm round d end.
 e=. 0.1^xm
 n=. e (>i.1:) a (^%!@]) i.>.a^.e [ a=. |y-m*^.2
 (2x^m) * 1++/*/\d%1+i.n
)
