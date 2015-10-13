/*REXX program uses the Runge─Kutta method to solve the differential equation:*/
/*             _____                ══ the exact solution:  y(t)=(t²+4)²/16 ══*/
/*   y'(t)═t² √ y(t)                ══════════════════════════════════════════*/

numeric digits 40;   d=digits()%2      /*use 40 digits,  but only show ½ that.*/
x0=0;       x1=10;   dx=.1;            n=1 + (x1-x0)/dx
y.=1
       do m=1  for n-1;                mm=m-1
       y.m=Runge_Kutta(dx, x0+dx*mm, y.mm)
       end   /*m*/

say center(x,13,'─')   center(y,d,'─')    ' '    center('relative error',d,'─')

       do i=0  to n-1  by 10;        x=(x0+dx*i)/1;             y2=(x*x/4+1)**2
       relE=format(y.i/y2-1,,13)/1;  if relE==0  then relE=' 0' /*adjust for 0*/
       say  center(x,13)    right(format(y.i,,12),d)     '  '   left(relE,d)
       end   /*i*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
rate:  return arg(1) * sqrt(arg(2))
/*────────────────────────────────────────────────────────────────────────────*/
Runge_Kutta:  procedure;                 parse arg dx,x,y
                                         k1 =  dx * rate(x      ,   y      )
                                         k2 =  dx * rate(x+dx/2 ,   y+k1/2 )
                                         k3 =  dx * rate(x+dx/2 ,   y+k2/2 )
                                         k4 =  dx * rate(x+dx   ,   y+k3   )
return y + (k1 + 2*k2 + 2*k3 + k4) / 6
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
