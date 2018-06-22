/*REXX program  solves the  closest pair  of  points  problem  (in two dimensions).     */
parse arg N low high seed .                      /*obtain optional arguments from the CL*/
if    N=='' |    N==","  then    N=   100        /*Not specified?  Then use the default.*/
if  low=='' |  low==","  then  low=     0        /* "      "         "   "   "     "    */
if high=='' | high==","  then high= 20000        /* "      "         "   "   "     "    */
if datatype(seed, 'W')   then call random ,,seed /*seed for RANDOM (BIF)  repeatability.*/
w=length(high);   w=w + (w//2==0)                /*W:   for aligning the output columns.*/
   /*╔══════════════════════╗*/      do j=1  for N            /*generate N random points*/
   /*║ generate  N  points. ║*/      @x.j=random(low, high)   /*    "    a random   X   */
   /*╚══════════════════════╝*/      @y.j=random(low, high)   /*    "    "    "     Y   */
                                     end   /*j*/              /*X  &  Y  make the point.*/
           A=1;   B=2                            /* [↓]  MINDD  is actually the  squared*/
minDD= (@x.A - @x.B)**2   +   (@y.A - @y.B)**2   /*distance between the first two points*/
                                                 /* [↓]  use of XJ & YJ speed things up.*/
    do   j=1   for N-1;   xj=@x.j;   yj=@y.j     /*find minimum distance between a ···  */
      do k=j+1  to N                             /*  ··· point and all the other points.*/
      dd=(xj - @x.k)**2  +  (yj - @y.k)**2       /*compute squared distance from points.*/
      if dd<minDD  then parse  value   dd  j  k    with    minDD  A  B
      end   /*k*/                                /* [↑]  needn't take SQRT of DD  (yet).*/
    end     /*j*/                                /* [↑]  when done, A & B are the points*/
                 $= 'For '   N   " points, the minimum distance between the two points:  "
say $ center("x", w, '═')" "      center('y', w, "═")      '  is: '     sqrt(abs(minDD))/1
say left('', length($) - 1)       "["right(@x.A, w)','           right(@y.A, w)"]"
say left('', length($) - 1)       "["right(@x.B, w)','           right(@y.B, w)"]"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g *.5'e'_ % 2
        do j=0  while h>9;      m.j=h;               h=h%2+1;       end  /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end  /*k*/;   return g
