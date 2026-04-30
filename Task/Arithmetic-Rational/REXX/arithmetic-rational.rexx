-- 21 Feb 2026
include Setting

say 'RATIONAL ARITHMETIC'
say version
say
a='1 2'; b='-3 4'; c='5 -6'; d='-7 -8'; e=3; f=1.666666666
say 'VALUES'
say 'a =' Rat2form(a)
say 'b =' Rat2form(b)
say 'c =' Rat2form(c)
say 'd =' Rat2form(d)
say 'e =' e
say 'f =' f
say
say 'BASICS'
say 'a+b =' Rat2form(AddQ(a,b))
say 'a-b =' Rat2form(SubQ(a,b))
say 'a*b =' Rat2form(MulQ(a,b))
say 'a/b =' Rat2form(DivQ(a,b))
say '-a  =' Rat2form(NegQ(a))
say '1/a =' Rat2form(InvQ(a))
say
say 'COMPARE'
say 'a<b  =' LtQ(a,b)
say 'a<=b =' LeQ(a,b)
say 'a=b  =' EqQ(a,b)
say 'a>=b =' GeQ(a,b)
say 'a>b  =' GtQ(a,b)
say 'a<>b =' NeQ(a,b)
say
say 'BONUS'
say 'Abs(c)      =' Rat2form(AbsQ(c))
say 'Float(b)    =' FloatQ(b)
say 'Neg(d)      =' Rat2form(NegQ(d))
say 'Power(a,e)  =' Rat2form(PowQ(a,e))
say 'Rational(f) =' Rat2form(RatQ(f))
say
say 'FORMULA'
g=SquareQ(a); h=MulQ(-2,MulQ(a,b)); i=MulQ(3,c); j=MulQ(-4,MulQ(a,PowQ(d,4))); k=5
say 'a^2-2ab+3c-4ad^4+5 =' Rat2form(AddQ(g,AddQ(h,AddQ(i,AddQ(j,k)))))
say
say 'PERFECT NUMBERS'
numeric digits 20
do c=6 to 2**19
   s=1 c; m=Isqrt(c)
   do f=2 to m
      if c//f=0 then
         s=AddQ(s,AddQ(1 f,f c))
   end f
   if EqQ(s,1) then
      say c 'is a perfect number'
end
call Timer
exit

-- All procedures ending with 'Q'; Rat2form; Isqrt; Timer
include Math
