/*REXX program uses the  Runge-Kutta  method  to solve the differential */
/*                   ____                                               */
/*equation: y'(t)=t²√y(t)  which has the exact solution: y(t)=(t²+4)²/16*/

numeric digits 40;   d=digits()%2      /*use forty digits, show ½ that. */
x0=0;       x1=10;   dx=.1;            n=1 + (x1-x0) / dx;        y.=1

       do m=1  for n-1;                mm=m-1
       y.m=Runge_Kutta(dx, x0+dx*mm, y.mm)
       end   /*m*/

say center(x,13,'─')  center(y,d,'─')  ' '  center('relative error',d,'─')

       do i=0  to n-1  by 10;         x=(x0+dx*i)/1;       y2=(x*x/4+1)**2
       relE=format(y.i/y2-1,,13)/1;   if relE=0  then relE=' 0'
       say  center(x,13)   right(format(y.i,,12),d)    '  '   left(relE,d)
       end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────RATE subroutine─────────────────────*/
rate:  return arg(1)*sqrt(arg(2))
/*──────────────────────────────────Runge_Kutta subroutine──────────────*/
Runge_Kutta:  procedure;                  parse arg dx,x,y
                                          k1 = dx * rate(x      , y      )
                                          k2 = dx * rate(x+dx/2 , y+k1/2 )
                                          k3 = dx * rate(x+dx/2 , y+k2/2 )
                                          k4 = dx * rate(x+dx   , y+k3   )
return y + (k1 + 2*k2 + 2*k3 + k4) / 6
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt:  procedure; parse arg x;   if x=0 then return 0; d=digits()
       numeric digits 11;        g=.sqrtG()
               do j=0 while p>9; m.j=p; p=p%2+1; end;  do k=j+5 to 0 by -1
       if m.k>11  then numeric digits m.k
       g=.5*(g+x/g); end;        numeric digits d;     return g/1
.sqrtG: numeric form;   m.=11;   p=d+d%4+2
       parse value format(x,2,1,,0) 'E0' with g 'E' _ .; return g*.5'E'_%2
