include Settings

say 'RATIONAL ARITHMETIC - 2 Mar 2025'
say version
say
a = '1 2'; b = '-3 4'; c = '5 -6'; d = '-7 -8'; e = 3; f = 1.666666666
say 'VALUES'
say 'a =' Rlst2form(a)
say 'b =' Rlst2form(b)
say 'c =' Rlst2form(c)
say 'd =' Rlst2form(d)
say 'e =' e
say 'f =' f
say
say 'BASICS'
say 'a+b     =' Rlst2form(Radd(a,b))
say 'a+b+c+d =' Rlst2form(Radd(a,b,c,d))
say 'a-b     =' Rlst2form(Rsub(a,b))
say 'a-b-c-d =' Rlst2form(Rsub(a,b,c,d))
say 'a*b     =' Rlst2form(Rmul(a,b))
say 'a*b*c*d =' Rlst2form(Rmul(a,b,c,d))
say 'a/b     =' Rlst2form(Rdiv(a,b))
say 'a/b/c/d =' Rlst2form(Rdiv(a,b,c,d))
say '-a      =' Rlst2form(Rneg(a))
say '1/a     =' Rlst2form(Rinv(a))
say
say 'COMPARE'
say 'a<b  =' Rlt(a,b)
say 'a<=b =' Rle(a,b)
say 'a=b  =' Req(a,b)
say 'a>=b =' Rge(a,b)
say 'a>b  =' Rgt(a,b)
say 'a<>b =' Rne(a,b)
say
say 'BONUS'
say 'Abs(c)      =' Rlst2form(Rabs(c))
say 'Float(b)    =' Rfloat(b)
say 'Neg(d)      =' Rlst2form(Rneg(d))
say 'Power(a,e)  =' Rlst2form(Rpow(a,e))
say 'Rational(f) =' Rlst2form(Rrat(f))
say
say 'FORMULA'
say 'a^2-2ab+3c-4ad^4+5 = ',
Rlst2form(Radd(Rpow(a,2),Rmul(-2,a,b),Rmul(3,c),Rmul(-4,a,Rpow(d,4)),5))
say
say 'PERFECT NUMBERS'
call time('r')
numeric digits 20
do c = 6 to 2**19
   s = 1 c; m = Isqrt(c)
   do f = 2 to m
      if c//f = 0 then do
         s = Radd(s,1 f,1 c/f)
      end
   end
   if Req(s,1) then
      say c 'is a perfect number'
end
say time('e')/1's'
exit

include Rational
include Functions
include Abend
