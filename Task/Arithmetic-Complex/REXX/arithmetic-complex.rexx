-- 19 May 2025
include Settings

say 'COMPLEX ARITHMETIC'
say version
say
a = '1 2'; b = '3 4'; c = '5 6'; d = '7 8'; i = I()
say 'VALUES'
say 'a =' crec2form(a)
say 'b =' crec2form(b)
say 'c =' crec2form(c)
say 'd =' crec2form(d)
say
say 'BASICS'
say 'i*i     =' crec2form(Csquare(i()))
say 'a+b     =' crec2form(Cadd(a,b))
say 'a-b     =' crec2form(Csub(a,b))
say 'a*b     =' crec2form(Cmul(a,b))
say 'a/b     =' crec2form(Cdiv(a,b))
say 'a^2     =' crec2form(Csquare(a,2))
say 'a^5     =' crec2form(Cpow(a,5))
say '-a      =' crec2form(Cneg(a))
say '1/a     =' crec2form(Cinv(a))
say 'a+b+c+d =' crec2form(Cadd(a,b,c,d))
say 'a-b-c-d =' crec2form(Csub(a,b,c,d))
say 'a*b*c*d =' crec2form(Cmul(a,b,c,d))
say 'a/b/c/d =' crec2form(Cnormal(Cdiv(a,b,c,d)))
say
say 'FORMULA'
say 'a^2-2ab+3c-4ad^4+5 =' ,
crec2form(Cadd(Csquare(a),Cmul(-2,a,b),Cmul(3,c),Cmul(-4,a,Cpower(d,4)),5))
say
say 'BONUS'
say 'Argument(a)  =' Carg(a)+0
say 'Conjugate(a) =' crec2form(Cconj(a))
say 'Imag(a)      =' Cim(a)
say 'Modulus(a)   =' Cmod(a)+0
say 'Polar(a)     =' Cpol2form(Cnormal(Crec2pol(a)))
say 'Real(a)      =' Cre(a)
say
say 'MORE'
say 'Arcsin(a) =' crec2form(Cnormal(Carcsin(a)))
say 'Exp(a)    =' crec2form(Cnormal(Cexp(a)))
say 'Ln(a)     =' crec2form(Cnormal(Cln(a)))
say 'Sin(a)    =' crec2form(Cnormal(Csin(a)))
say 'Sqrt(a)   =' crec2form(Cnormal(Csqrt(a)))
say 'i^i       =' crec2form(Cnormal(Cpower(i,i)))
exit

include Complex
include Functions
include Constants
include Abend
