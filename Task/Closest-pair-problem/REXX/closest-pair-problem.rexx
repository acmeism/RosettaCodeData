/*REXX program solves the  closest pair of points problem  in two dimensions. */
parse arg N low high seed .            /*obtain optional arguments from the CL*/
if    N=='' |    N==','  then    N=100 /*N  not specified?   Then use default.*/
if  low=='' |  low==','  then  low=0
if high=='' | high==','  then high=20000
if seed\==''& seed\==',' then call random ,,seed  /*seed for RANDOM repeatable*/
w=length(high);   w=w + (w//2==0)
  /*╔══════════════════════╗*/      do j=1  for N /*generate N random points. */
  /*║ generate  N  points. ║*/      @x.j=random(low,high)      /*a random  X. */
  /*╚══════════════════════╝*/      @y.j=random(low,high)      /*"    "    Y. */
                                    end   /*j*/
          A=1; B=2
minDD=(@x.A-@x.B)**2 + (@y.A-@y.B)**2  /*distance between first two points.   */

      do   j=1   for N-1               /*find minimum distance between a ···  */
        do k=j+1  to N                 /*  ··· point and all the other points.*/
        dd=(@x.j - @x.k)**2  +  (@y.j - @y.k)**2
        if dd\=0  then  if dd<minDD   then do;  minDD=dd;  A=j;  B=k;  end
        end   /*k*/
      end     /*j*/                    /* [↑]  when done,  A & B  are the ones*/

_= 'For '   N    " points, the minimum distance between the two points:  "
say _  center("x",w,'═')" "    center('y',w,"═")    '  is: '    sqrt(abs(minDD))
say left('', length(_)-1)      '['right(@x.A, w)","         right(@y.A, w)"]"
say left('', length(_)-1)      '['right(@x.B, w)","         right(@y.B, w)"]"
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
