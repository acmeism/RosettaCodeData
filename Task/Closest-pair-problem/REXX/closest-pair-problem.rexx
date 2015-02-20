/*REXX program solves the closest pair of points problem in 2 dimensions*/
parse arg N low high seed .            /*get optional arguments from CL.*/
if    N=='' |    N==','  then    N=100 /*N  not specified?  Use default.*/
if  low=='' |  low==','  then  low=0
if high=='' | high==','  then high=20000
if seed\==''& seed\==',' then call random ,,seed  /*seed for repeatable.*/
w=length(high);   w=w + (w//2==0)
  /*╔══════════════════════╗*/      do j=1  for N    /*gen N random pts.*/
  /*║ generate  N  points. ║*/      @x.j=random(low,high)    /*random X.*/
  /*╚══════════════════════╝*/      @y.j=random(low,high)    /*   "   Y.*/
                                    end   /*j*/
          A=1; B=2
minDD=(@x.A-@x.B)**2 + (@y.A-@y.B)**2  /*distance between 1st two points*/

      do   j=1   for N-1               /*find min distance between a ···*/
        do k=j+1  to N                 /*point and all the other points.*/
        dd=(@x.j - @x.k)**2  +  (@y.j - @y.k)**2
        if dd\=0  then  if dd<minDD   then do;  minDD=dd;  A=j;  B=k;  end
        end   /*k*/
      end     /*j*/                    /* [↑]  when done,  A & B  are it*/

_= 'For '   N    " points, the minimum distance between the two points:  "
say _ center("x",w,'═')" "  center('y',w,"═")  '  is: '   sqrt(abs(minDD))
say left('', length(_)-1)      '['right(@x.A, w)","      right(@y.A, w)"]"
say left('', length(_)-1)      '['right(@x.B, w)","      right(@y.B, w)"]"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SQRT subroutine───────────────────────*/
sqrt: procedure; parse arg x; if x=0 then return 0; d=digits(); numeric form
numeric digits 11;p=d+d%4+2;parse value format(x,2,1,,0) 'E0' with g 'E' _ .
g=g*.5'E'_%2; m.=11;        do j=0  while p>9;    m.j=p;    p=p%2+1;     end
  do k=j+5 to 0 by -1; if m.k>11  then numeric digits m.k; g=.5*(g+x/g); end
numeric digits d;  return g/1
