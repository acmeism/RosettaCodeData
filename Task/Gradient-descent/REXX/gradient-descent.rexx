/*REXX pgm searches for minimum values of the bi─variate function (AKA steepest descent)*/
numeric digits (length( e() ) - length(.) ) % 2  /*use half of number decimal digs in E.*/
tolerance=  1e-30                                /*use a much smaller tolerance for REXX*/
    alpha=  0.1
      x.0=  0.1;     x.1= -1
say center(' testing for the steepest descent method ', 79, "═")
call steepestD                                   /* ┌──◄── # digs past dec. point ─►───┐*/
say 'The minimum is at:     x[0]='      format(x.0,,9)    "     x[1]="     format(x.1,,9)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
e:     return 2.718281828459045235360287471352662497757247093699959574966967627724
g:     return (x.0-1)**2  *  exp(- (x.1**2) )    +    x.1 * (x.1 + 2)  *  exp(-2 * x.0**2)
/*──────────────────────────────────────────────────────────────────────────────────────*/
gradG: x= x.0;               y= x.1              /*define X and Y  from the  X  array.  */
       xm= x-1;              eny2= exp(-y*y);   enx2= exp(-2 * x**2)        /*shortcuts.*/
       z.0=  2 * xm        * eny2   -   4 * x * enx2 * y * (y+2)
       z.1= -2 * xm**2 * y * eny2   +           enx2     * (y+2)   +   enx2 * y
       return                                    /*a rough calculation of the gradient. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
steepestD: g0= g()                               /*the initial estimate of the result.  */
           call gradG                            /*calculate the initial gradient.      */
           delG= sqrt(z.0**2  +  z.1**2)         /*    "      "     "    norm.          */
           b= alpha / delG
                             do while delG>tolerance
                             x.0= x.0   -   b * z.0;               x.1= x.1   -   b * z.1
                             call gradG
                             delG= sqrt(z.0**2  +  z.1**2);        if delG=0  then return
                             b= alpha / delG
                             g1= g()                                     /*find minimum.*/
                             if g1>g0  then alpha= alpha * .5            /*adjust ALPHA.*/
                                       else    g0= g1                    /*   "   G0.   */
                             end   /*while*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
exp:  procedure; parse arg x; ix= x%1;  if abs(x-ix)>.5  then ix= ix + sign(x);  x= x - ix
      z=1;  _=1;  w=z;   do j=1;  _= _*x/j;  z= (z+_)/1;  if z==w  then leave;  w= z;  end
      if z\==0  then z= z * e() ** ix;                                          return z/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d= digits();  numeric digits;  h= d+6
      numeric form; m.=9; parse value format(x,2,1,,0) 'E0' with g "E" _ .; g=g *.5'e'_ %2
        do j=0  while h>9;      m.j=h;                h= h % 2 + 1;   end  /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;   g=(g+x/g)*.5;   end  /*k*/; return g
