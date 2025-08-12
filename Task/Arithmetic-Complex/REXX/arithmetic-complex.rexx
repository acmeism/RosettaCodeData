-- 7 Aug 2025
include Settings

say 'COMPLEX ARITHMETIC'
say version
say
a = '1 2'; b = '3 4'; c = '5 6'; d = '7 8'; i = I()
say 'VALUES'
say 'a =' Rec2FormC(a)
say 'b =' Rec2FormC(b)
say 'c =' Rec2FormC(c)
say 'd =' Rec2FormC(d)
say
say 'BASICS'
say 'i*i     =' Rec2FormC(SquareC(i()))
say 'a+b     =' Rec2FormC(AddC(a,b))
say 'a-b     =' Rec2FormC(SubC(a,b))
say 'a*b     =' Rec2FormC(MulC(a,b))
say 'a/b     =' Rec2FormC(DivC(a,b))
say 'a^2     =' Rec2FormC(SquareC(a,2))
say 'a^5     =' Rec2FormC(PowC(a,5))
say '-a      =' Rec2FormC(NegC(a))
say '1/a     =' Rec2FormC(InvC(a))
say 'a+b+c+d =' Rec2FormC(AddC(a,b,c,d))
say 'a-b-c-d =' Rec2FormC(SubC(a,b,c,d))
say 'a*b*c*d =' Rec2FormC(MulC(a,b,c,d))
say 'a/b/c/d =' Rec2FormC(Normal(DivC(a,b,c,d)))
say
say 'FORMULA'
say 'a^2-2ab+3c-4ad^4+5 =' ,
Rec2FormC(AddC(SquareC(a),MulC(-2,a,b),MulC(3,c),MulC(-4,a,PowerC(d,4)),5))
say
say 'BONUS'
say 'Argument(a)  =' ArgC(a)+0
say 'Conjugate(a) =' Rec2FormC(ConjC(a))
say 'Imag(a)      =' ImC(a)
say 'Modulus(a)   =' ModC(a)+0
say 'Polar(a)     =' Pol2FormC(Normal(Rec2PolC(a)))
say 'Real(a)      =' ReC(a)
say
say 'MORE'
say 'Arcsin(a) =' Rec2FormC(Normal(ArcSinC(a)))
say 'Exp(a)    =' Rec2FormC(Normal(ExpC(a)))
say 'Ln(a)     =' Rec2FormC(Normal(LnC(a)))
say 'Sin(a)    =' Rec2FormC(Normal(SinC(a)))
say 'Sqrt(a)   =' Rec2FormC(Normal(SqRtC(a)))
say 'i^i       =' Rec2FormC(Normal(PowerC(i,i)))
exit

include Math
