-- 28 Jul 2025
include Settings

say 'RATIONAL ARITHMETIC'
say version
say
a = '1 2'; b = '-3 4'; c = '5 -6'; d = '-7 -8'; e = 3; f = 1.666666666
say 'VALUES'
say 'a =' Lst2FormQ(a)
say 'b =' Lst2FormQ(b)
say 'c =' Lst2FormQ(c)
say 'd =' Lst2FormQ(d)
say 'e =' e
say 'f =' f
say
say 'BASICS'
say 'a+b     =' Lst2FormQ(AddQ(a,b))
say 'a+b+c+d =' Lst2FormQ(AddQ(a,b,c,d))
say 'a-b     =' Lst2FormQ(SubQ(a,b))
say 'a-b-c-d =' Lst2FormQ(SubQ(a,b,c,d))
say 'a*b     =' Lst2FormQ(MulQ(a,b))
say 'a*b*c*d =' Lst2FormQ(MulQ(a,b,c,d))
say 'a/b     =' Lst2FormQ(DivQ(a,b))
say 'a/b/c/d =' Lst2FormQ(DivQ(a,b,c,d))
say '-a      =' Lst2FormQ(NegQ(a))
say '1/a     =' Lst2FormQ(InvQ(a))
say
say 'Compare'
say 'a<b  =' LtQ(a,b)
say 'a<=b =' LeQ(a,b)
say 'a=b  =' EqQ(a,b)
say 'a>=b =' GeQ(a,b)
say 'a>b  =' GtQ(a,b)
say 'a<>b =' NeQ(a,b)
say
say 'BONUS'
say 'Abs(c)      =' Lst2FormQ(AbsQ(c))
say 'Float(b)    =' FloatQ(b)
say 'Neg(d)      =' Lst2FormQ(NegQ(d))
say 'Power(a,e)  =' Lst2FormQ(PowQ(a,e))
say 'Rational(f) =' Lst2FormQ(RatQ(f))
say
say 'FORMULA'
say 'a^2-2ab+3c-4ad^4+5 = ',
Lst2FormQ(AddQ(PowQ(a,2),MulQ(-2,a,b),MulQ(3,c),MulQ(-4,a,PowQ(d,4)),5))
say
say 'Perfect numbers'
call Time('r')
numeric digits 20
do c = 6 to 2**19
   s = 1 c; m = Isqrt(c)
   do f = 2 to m
      if c//f = 0 then do
         s = AddQ(s,1 f,1 c/f)
      end
   end
   if EqQ(s,1) then
      say c 'is a perfect number'
end
say Time('e')/1's'
exit

include Math
