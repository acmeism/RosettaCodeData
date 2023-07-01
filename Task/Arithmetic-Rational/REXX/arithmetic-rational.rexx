/*REXX program implements a reasonably complete  rational arithmetic  (using fractions).*/
L=length(2**19 - 1)                              /*saves time by checking even numbers. */
     do j=2  by 2  to 2**19 - 1;       s=0       /*ignore unity (which can't be perfect)*/
     mostDivs=eDivs(j);                @=        /*obtain divisors>1; zero sum; null @. */
       do k=1  for  words(mostDivs)              /*unity isn't return from  eDivs  here.*/
       r='1/'word(mostDivs, k);        @=@ r;         s=$fun(r, , s)
       end   /*k*/
     if s\==1  then iterate                      /*Is sum not equal to unity?   Skip it.*/
     say 'perfect number:'       right(j, L)       "   fractions:"            @
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$div: procedure;  parse arg x;   x=space(x,0);   f= 'fractional division'
      parse var x n '/' d;       d=p(d 1)
      if d=0               then call err  'division by zero:'            x
      if \datatype(n,'N')  then call err  'a non─numeric numerator:'     x
      if \datatype(d,'N')  then call err  'a non─numeric denominator:'   x
      return n/d
/*──────────────────────────────────────────────────────────────────────────────────────*/
$fun: procedure;  parse arg z.1,,z.2 1 zz.2;    arg ,op;  op=p(op '+')
F= 'fractionalFunction';        do j=1  for 2;  z.j=translate(z.j, '/', "_");   end  /*j*/
if abbrev('ADD'      , op)                               then op= "+"
if abbrev('DIVIDE'   , op)                               then op= "/"
if abbrev('INTDIVIDE', op, 4)                            then op= "÷"
if abbrev('MODULUS'  , op, 3) | abbrev('MODULO', op, 3)  then op= "//"
if abbrev('MULTIPLY' , op)                               then op= "*"
if abbrev('POWER'    , op)                               then op= "^"
if abbrev('SUBTRACT' , op)                               then op= "-"
if z.1==''                                               then z.1= (op\=="+" & op\=='-')
if z.2==''                                               then z.2= (op\=="+" & op\=='-')
z_=z.2
                                                 /* [↑]  verification of both fractions.*/
  do j=1  for 2
  if pos('/', z.j)==0    then z.j=z.j"/1";         parse var  z.j  n.j  '/'  d.j
  if \datatype(n.j,'N')  then call err  'a non─numeric numerator:'     n.j
  if \datatype(d.j,'N')  then call err  'a non─numeric denominator:'   d.j
  if d.j=0               then call err  'a denominator of zero:'       d.j
                                               n.j=n.j/1;          d.j=d.j/1
             do  while \datatype(n.j,'W');     n.j=(n.j*10)/1;     d.j=(d.j*10)/1
             end  /*while*/                      /* [↑]   {xxx/1}  normalizes a number. */
  g=gcd(n.j, d.j);    if g=0  then iterate;  n.j=n.j/g;          d.j=d.j/g
  end    /*j*/

 select
 when op=='+' | op=='-' then do;  l=lcm(d.1,d.2);    do j=1  for 2;  n.j=l*n.j/d.j;  d.j=l
                                                     end   /*j*/
                                  if op=='-'  then n.2= -n.2;        t=n.1 + n.2;    u=l
                             end
 when op=='**' | op=='↑'  |,
      op=='^'  then do;  if \datatype(z_,'W')  then call err 'a non─integer power:'  z_
                    t=1;  u=1;     do j=1  for abs(z_);  t=t*n.1;  u=u*d.1
                                   end   /*j*/
                    if z_<0  then parse value   t  u   with   u  t      /*swap  U and T */
                    end
 when op=='/'  then do;      if n.2=0   then call err  'a zero divisor:'   zz.2
                             t=n.1*d.2;    u=n.2*d.1
                    end
 when op=='÷'  then do;      if n.2=0   then call err  'a zero divisor:'   zz.2
                             t=trunc($div(n.1 '/' d.1));    u=1
                    end                           /* [↑]  this is integer division.     */
 when op=='//' then do;      if n.2=0   then call err  'a zero divisor:'   zz.2
                    _=trunc($div(n.1 '/' d.1));     t=_ - trunc(_) * d.1;            u=1
                    end                          /* [↑]  modulus division.              */
 when op=='ABS'  then do;   t=abs(n.1);       u=abs(d.1);        end
 when op=='*'    then do;   t=n.1 * n.2;      u=d.1 * d.2;       end
 when op=='EQ' | op=='='                then return $div(n.1 '/' d.1)  = fDiv(n.2 '/' d.2)
 when op=='NE' | op=='\=' | op=='╪' | ,
                            op=='¬='    then return $div(n.1 '/' d.1) \= fDiv(n.2 '/' d.2)
 when op=='GT' | op=='>'                then return $div(n.1 '/' d.1) >  fDiv(n.2 '/' d.2)
 when op=='LT' | op=='<'                then return $div(n.1 '/' d.1) <  fDiv(n.2 '/' d.2)
 when op=='GE' | op=='≥'  | op=='>='    then return $div(n.1 '/' d.1) >= fDiv(n.2 '/' d.2)
 when op=='LE' | op=='≤'  | op=='<='    then return $div(n.1 '/' d.1) <= fDiv(n.2 '/' d.2)
 otherwise       call err  'an illegal function:'   op
 end   /*select*/

if t==0  then return 0;            g=gcd(t, u);             t=t/g;                   u=u/g
if u==1  then return t
              return t'/'u
/*──────────────────────────────────────────────────────────────────────────────────────*/
eDivs: procedure; parse arg x 1 b,a
         do j=2  while j*j<x;       if x//j\==0  then iterate;   a=a j;   b=x%j b;     end
       if j*j==x  then return a j b;                                            return a b
/*───────────────────────────────────────────────────────────────────────────────────────────────────*/
err:   say;   say '***error*** '    f     " detected"   arg(1);    say;         exit 13
gcd:   procedure; parse arg x,y; if x=0  then return y;  do until _==0; _=x//y; x=y; y=_; end; return x
lcm:   procedure; parse arg x,y; if y=0  then return 0; x=x*y/gcd(x, y);        return x
p:     return word( arg(1), 1)
