/*REXX program converts decimal  ◄───►  balanced ternary;  it also performs arithmetic. */
numeric digits 10000                             /*be able to handle  gihugic  numbers. */
Ao = '+-0++0+' ;    Abt =      Ao                /*   [↓]  2 literals used by subroutine*/
Bo =    '-436' ;    Bbt = d2bt(Bo);                    @ = "(decimal)"
Co =   '+-++-' ;    Cbt =      Co ;                   @@ = "balanced ternary ="
                  call btShow  '[a]',       Abt
                  call btShow  '[b]',       Bbt
                  call btShow  '[c]',       Cbt
                  say;                      $bt = btMul(Abt, btSub(Bbt, Cbt) )
                  call btShow '[a*(b-c)]',  $bt
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
d2bt: procedure; parse arg x 1;  x= x / 1;    p= 0;  $.= '-';   $.1= "+";   $.0= 0;     #=
                    do  until x==0;           _= (x // (3** (p+1) ) )  %  3**p
                    if _== 2  then _= -1
                              else if _== -2  then _= 1
                    x= x  -  _ * (3**p);      p= p + 1;                     #= $._  ||  #
                    end   /*until*/;          return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
bt2d: procedure; parse arg x;  r= reverse(x);  $.= -1;  $.0= 0;  #= 0;    _= '+';   $._= 1
                    do j=1  for length(x);  _= substr(r, j, 1);  #= #  +  $._ * 3 ** (j-1)
                    end   /*j*/;                         return #
/*──────────────────────────────────────────────────────────────────────────────────────*/
btAdd: procedure; parse arg x,y;    rx= reverse(x);      ry= reverse(y);          carry= 0
       @.= 0;   _= '-';   @._= -1;   _= "+";  @._= 1;  $.= '-';   $.0= 0;   $.1= "+";   #=
                                           do j=1  for max( length(x), length(y) )
                                           x_= substr(rx, j, 1);            xn= @.x_
                                           y_= substr(ry, j, 1);            yn= @.y_
                                           s= xn + yn + carry;           carry= 0
                                           if s== 2  then do;   s=-1;    carry= 1;    end
                                           if s== 3  then do;   s= 0;    carry= 1;    end
                                           if s==-2  then do;   s= 1;    carry=-1;    end
                                           #= $.s || #
                                           end   /*j*/
       if carry\==0  then #= $.carry || #;                      return btNorm(#)
/*──────────────────────────────────────────────────────────────────────────────────────*/
btMul: procedure; parse arg x 1 x1 2, y 1 y1 2; if x==0 | y==0  then return 0;  S= 1;  P=0
       x= btNorm(x); y= btNorm(y); Lx= length(x); Ly= length(y)  /*handle: 0-xxx values.*/
       if x1=='-'  then do;   x= btNeg(x);   S= -S;   end        /*positate the number. */
       if y1=='-'  then do;   y= btNeg(y);   S= -S;   end        /*    "     "    "     */
       if Ly>Lx    then parse value  x y  with  y x              /*optimize  "    "     */
                                             do   until  y==0    /*keep adding 'til done*/
                                             P= btAdd(P,  x )    /*multiple the hard way*/
                                             y= btSub(y, '+')    /*subtract  1  from  Y.*/
                                             end   /*until*/
       if S==-1  then P= btNeg(P);  return P       /*adjust the product's sign;  return.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
btNeg:  return translate( arg(1), '-+', "+-")                    /*negate bal_ternary #.*/
btNorm: _= strip(arg(1), 'L', 0);  if _==''  then _=0;  return _ /*normalize the number.*/
btSub:  return btAdd( arg(1), btNeg( arg(2) ) )                  /*subtract two BT args.*/
btShow: say center( arg(1), 9)  right( arg(2), 20)  @@  right( bt2d(arg(2)), 9) @;  return
