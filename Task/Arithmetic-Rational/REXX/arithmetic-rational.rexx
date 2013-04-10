/*REXX pgm implements a reasonably complete rational arithmetic (fract.)*/
L=length(2**19-1)                      /*saves time by checking even #s.*/
     do j=2  to 2**19-1  by 2          /*ignore unity (can't be perfect)*/
     $=divisors(j);  s=0;  @=          /*get divisors, zero sum, null @.*/
                               do k=2  to  words($)      /*ignore unity.*/
                               r='1/'word($,k);  @=@ r;   s=fractFun(r,,s)
                               end   /*k*/
     if s\==1  then iterate
     say 'perfect number:' right(j,L)  '   fractions:' @
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FRACTDIV subroutine─────────────────*/
fractDiv: procedure;  parse arg x;    x=space(x,0);       f='FractDiv'
parse var x n '/' d;                  d=p(d 1)
if d=0        then call err 'division by zero:'           x
if \isNum(n)  then call err 'a not numeric numerator:'    x
if \isNum(d)  then call err 'a not numeric denominator:'  x
return n/d
/*──────────────────────────────────FRACTFUN subroutine─────────────────*/
fractFun: procedure;  parse arg z.1,,z.2 1 zz.2,f;  arg ,op;  op=p(op '+')
f='FractFun';    do j=1  for 2;   z.j=translate(z.j,'/',"_");   end  /*j*/
if abbrev('ADD'       ,op)    then op='+'
if abbrev('DIVIDE'    ,op)    then op='/'
if abbrev('INTDIVIDE' ,op,4)  then op='÷'
if abbrev('MODULO'    ,op,3) | abbrev('MODULUS'   ,op,3)  then op='//'
if abbrev('MULTIPLY'  ,op)    then op='*'
if abbrev('POWER'     ,op)    then op='^'
if abbrev('SUBTRACT'  ,op)    then op='-'
if z.1==''                    then z.1=(op\=="+" & op\=='-') /*unary +,-*/
if z.2==''                    then z.2=(op\=="+" & op\=='-')
z_=z.2

  do j=1  for 2                        /*verification of both fractions.*/
  if pos('/',z.j)==0  then z.j=z.j"/1";     parse var  z.j  n.j  '/'  d.j
  if \isNum(n.j)  then call err 'a not numeric numerator:'    n.j
  if \isNum(d.j)  then call err 'a not numeric denominator:'  d.j
  n.j=n.j/1;      d.j=d.j/1
             do  while \isInt(n.j);   n.j=(n.j*10)/1;     d.j=(d.j*10)/1
             end  /*while*/            /* [↑]  normalize both numbers.  */
  if d.j=0          then call err 'a denominator of zero:'    d.j
  g=gcd(n.j,d.j);   if g=0  then iterate;     n.j=n.j/g;      d.j=d.j/g
  end    /*j*/

 select
 when op=='**' | op=='↑'  |,
      op=='^' then do; if \isInt(z_) then call err 'a not integer power:' z_
                   t=1;  u=1;     do j=1  for abs(z_);  t=t*n.1;  u=u*d.1
                                  end   /*j*/
                   if z_<0  then parse value t u with u t
                   end
 when op=='/' then do;      if n.2=0 then call err 'a zero divisor:' zz.2
                   t=n.1*d.2;    u=n.2*d.1
                   end
 when op=='÷' then do;      if n.2=0 then call err 'a zero divisor:' zz.2
                   t=trunc(fractDiv(n.1 '/' d.1));    u=1
                   end                 /* [↑] integer division.         */
 when op=='//' then do;     if n.2=0 then call err 'a zero divisor:' zz.2
                    _=trunc(fractDiv(n.1 '/' d.1)); t=_-trunc(_)*d.1;  u=1
                    end                /* [↑] modulus division.         */
 when op=='+' |,
      op=='-' then do; l=lcm(d.1 d.2); do j=1  for 2; n.j=l*n.j/d.j; d.j=l
                                       end   /*j*/
                   if op=='-'  then n.2=-n.2;         t=n.1+n.2;       u=l
                   end
 when op=='ABS'  then do;   t=abs(n.1);    u=abs(d.1);    end
 when op=='*'    then do;   t=n.1*n.2;     u=d.1*d.2;     end
 when op=='EQ' |,
      op=='='  then return fractDiv(n.1 '/' d.1)  =  fractDiv(n.2 '/' d.2)
 when op=='NE' | op=='\=' | op=='╪'  |,
      op=='¬=' then return fractDiv(n.1 '/' d.1) \=  fractDiv(n.2 '/' d.2)
 when op=='GT' |,
      op=='>'  then return fractDiv(n.1 '/' d.1)  >  fractDiv(n.2 '/' d.2)
 when op=='LT' |,
      op=='<'  then return fractDiv(n.1 '/' d.1)  <  fractDiv(n.2 '/' d.2)
 when op=='GE' | op=='≥'  |,
      op=='>=' then return fractDiv(n.1 '/' d.1)  >= fractDiv(n.2 '/' d.2)
 when op=='LE' | op=='≤'  |,
      op=='<=' then return fractDiv(n.1 '/' d.1)  <= fractDiv(n.2 '/' d.2)
 otherwise     call err 'an illegal function:'  op
 end   /*select*/

if t==0  then return 0;        g=gcd(t,u);           t=t/g;          u=u/g
if u==1  then return t
              return t'/'u
/*─────────────────────────────general 1─line subs─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
divisors: procedure; parse arg x 1 b; if x=1 then return 1; a=1; o=x//2; do j=2+o by 1+o while j*j<x; if x//j\==0 then iterate; a=a j; b=x%j b; end; if j*j==x then b=j b; return a b
err:      say; say '***error!***'; say; say f "detected" arg(1); say; exit 13
gcd:procedure;$=;do i=1 for arg();$=$ arg(i);end;parse var $ x z .;if x=0 then x=z;x=abs(x);do j=2 to words($);y=abs(word($,j));if y=0 then iterate;do until _==0;_=x//y;x=y;y=_;end;end;return x
isInt:    return datatype(arg(1),'W')
isNum:    return datatype(arg(1),'N')
lcm: procedure;  $=;    do j=1 for arg();  $=$ arg(j);  end;        x=abs(word($,1));         do k=2 to words($);  !=abs(word($,k));  if !=0 then return 0;  x=x*!/gcd(x,!);  end;       return x
p:        return word(arg(1),1)
