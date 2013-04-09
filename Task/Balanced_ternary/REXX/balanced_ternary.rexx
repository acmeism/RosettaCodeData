/*REXX pgm converts decimal ◄───► balanced ternary; also performs arith.*/
numeric digits 10000                   /*handle almost any size numbers.*/
Ao = '+-0++0+'   ;   Abt =      Ao     /*   [↓]  2 literals used by sub.*/
Bo =    '-436'   ;   Bbt = d2bt(Bo)    ;     @ = '(decimal)'
Co =   '+-++-'   ;   Cbt =      Co     ;    @@ = 'balanced ternary ='
                call btShow  '[a]',        Abt
                call btShow  '[b]',        Bbt
                call btShow  '[c]',        Cbt
                say;                       $bt = btMul(Abt,btSub(Bbt,Cbt))
                call btshow '[a*(b-c)]',   $bt
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BT2D subroutine─────────────────────*/
d2bt: procedure; parse arg x 1;   p=0;   $.='-';    $.1='+';   $.0=0;   #=
x=x/1
          do  until x==0;       _=(x//(3**(p+1)))%3**p
          if _==2  then _=-1;   if _=-2  then _=1
          x=x-_*(3**p);         p=p+1;                       #=$._ || #
          end   /*until*/
return #
/*──────────────────────────────────BT2D subroutine─────────────────────*/
bt2d: procedure; parse arg x; r=reverse(x); #=0; $.=-1; $.0=0; _='+'; $._=1
          do j=1  for length(x);  _=substr(r,j,1);  #=#+$._*3**(j-1);  end
return #
/*──────────────────────────────────BTADD subroutine────────────────────*/
btAdd: procedure;  parse arg x,y;   rx=reverse(x);  ry=reverse(y); carry=0
$.='-';   $.0=0;   $.1='+';   @.=0;   _='-';   @._=-1;  _="+";  @._=1;  #=

                                   do j=1  for max(length(x),length(y))
                                   x_=substr(rx,j,1);        xn=@.x_
                                   y_=substr(ry,j,1);        yn=@.y_
                                   s=xn+yn+carry    ;        carry=0
                                   if s== 2  then do; s=-1;  carry= 1; end
                                   if s== 3  then do; s= 0;  carry= 1; end
                                   if s==-2  then do; s= 1;  carry=-1; end
                                   #=$.s || #
                                   end   /*j*/
if carry\==0  then #=$.carry || #;                        return btNorm(#)
/*──────────────────────────────────BTMUL subroutine────────────────────*/
btMul: procedure;  parse arg x,y;   if x==0 | y==0  then return 0;     S=1
x=btNorm(x);       y=btNorm(y)                   /*handle: 0-xxx values.*/
if left(x,1)=='-'        then do;   x=btNeg(x);  S=-S;  end  /*positate.*/
if left(y,1)=='-'        then do;   y=btNeg(y);  S=-S;  end  /*positate.*/
if length(y)>length(x)   then parse value  x y   with   y x  /*optimize.*/
P=0
                             do   until  y==0    /*keep adding 'til done*/
                             P=btAdd(P,x)        /*multiple the hard way*/
                             y=btSub(y,'+')      /*subtract  1  from Y. */
                             end   /*until*/
if S==-1  then P=btNeg(P)                        /*adjust product sign. */
return P                                         /*return the product P.*/
/*───────────────────────────────one-line subroutines───────────────────*/
btNeg:  return translate(arg(1), '-+', "+-")     /*negate the bal_tern #*/
btNorm: _=strip(arg(1),'L',0); if _==''  then _=0;  return _ /*normalize*/
btSub:  return btAdd(arg(1), btNeg(arg(2)))      /*subtract two BT args.*/
btShow: say center(arg(1),9) right(arg(2),20) @@ right(bt2d(arg(2)),9) @; return
