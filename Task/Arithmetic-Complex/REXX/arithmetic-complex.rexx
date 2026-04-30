-- 25 Apr 2026
include Setting

say 'COMPLEX ARITHMETIC'
say version
say
t = '1 2'; u = '3 4'; v = '5 6'; w = '7 8'; i = I()
say 'VALUES'
say 't =' Rec2FormC(t)
say 'u =' Rec2FormC(u)
say 'v =' Rec2FormC(v)
say 'w =' Rec2FormC(w)
say
say 'BASICS'
say 'i*i =' Rec2FormC(SquareC(i))
say 't+u =' Rec2FormC(AddC(t,u))
say 't-u =' Rec2FormC(SubC(t,u))
say 't*u =' Rec2FormC(MulC(t,u))
say 't/u =' Rec2FormC(DivC(t,u))
say 't^2 =' Rec2FormC(SquareC(t,2))
say 't^5 =' Rec2FormC(PowC(t,5))
say '-t  =' Rec2FormC(NegC(t))
say '1/t =' Rec2FormC(InvC(t))
say
say 'SUM AND PRODUCT OF A LIST'
say 't+u+v+w =' Rec2FormC(AddCL(t';'u';'v';'w))
say 't*u*v*w =' Rec2FormC(MulCL(t';'u';'v';'w))
say
say 'FORMULA'
say 't^2-2tu+3v-4tw^4+5 =' ,
Rec2FormC(AddCL(SquareC(t)';'MulCL(-2';'t';'u)';'MulC(3,v)';'MulCL(-4';'t';'PowC(w,4))';'5))
say
say 'BONUS'
say 'Argument(t)  =' ArgC(t)+0
say 'Conjugate(t) =' Rec2FormC(ConjC(t))
say 'Imag(t)      =' ImC(t)
say 'Modulus(t)   =' ModC(t)+0
say 'Polar(t)     =' Pol2FormC(Normal(Rec2PolC(t)))
say 'Real(t)      =' ReC(t)
say
say 'MORE'
say 'Arcsin(t) =' Rec2FormC(Normal(ArcSinC(t)))
say 'Exp(t)    =' Rec2FormC(Normal(ExpC(t)))
say 'Ln(t)     =' Rec2FormC(Normal(LnC(t)))
say 'Sin(t)    =' Rec2FormC(Normal(SinC(t)))
say 'Sqrt(t)   =' Rec2FormC(Normal(SqRtC(t)))
say 'i^i       =' Rec2FormC(Normal(PowerC(i,i)))
exit

include Math
