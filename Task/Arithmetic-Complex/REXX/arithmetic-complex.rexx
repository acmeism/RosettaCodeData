/*REXX program to show how to support math functions for complex numbers*/
x = '(5,3i)'               /*this little piggy uses  "I"   (or  "i") ···*/
y = '( .5,  6j)'           /*this little piggy uses  "J"   (or  "j") ···*/

sum  = Cadd(x,y) ;  say '      addition:   '  x  " + "  y  ' = '  sum
dif  = Csub(x,y) ;  say '   subtraction:   '  x  " + "  y  ' = '  dif
prod = Cmul(x,y) ;  say 'multiplication:   '  x  " * "  y  ' = '  prod
quot = Cdiv(x,y) ;  say '      division:   '  x  " ÷ "  y  ' = '  quot
inv  = Cinv(x)   ;  say '       inverse:   '  x  "                = " inv
cnjX = Ccnj(x)   ;  say '  conjugate of:   '  x  "                = " cnjX
negX = Cneg(x)   ;  say '   negation of:   '  x  "                = " negX
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────one─liners──────────────────────────────────────────────*/
Ccnj: procedure; arg a ',' b,c ',' d; call Cg; r1=a;       r2=-b;      return Cr()
Cadd: procedure; arg a ',' b,c ',' d; call Cg; r1=a+c;     r2=b+d;     return Cr()
Csub: procedure; arg a ',' b,c ',' d; call Cg; r1=a-c;     r2=b-d;     return Cr()
Cmul: procedure; arg a ',' b,c ',' d; call Cg; r1=a*c-b*d; r2=b*c+a*d; return Cr()
Cdiv: procedure; arg a ',' b,c ',' d; call Cg;_=c*c+d*d;r1=(a*c+b*d)/_;r2=(b*c-a*d)/_;return Cr()
Cdej: return  word(translate(arg(1), , '{[(JI)]}')  0,  1)
Cg:   a=Cdej(a);  b=Cdej(b);  c=Cdej(c);  d=Cdej(d);   return
Cinv: return  Cdiv(1,  arg(1))
Cneg: return  Cmul(arg(1), -1)
Cr:   _='['r1;   if r2\=0  then _=_','r2"j";           return _']'
