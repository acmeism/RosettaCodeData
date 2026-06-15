-- 12 Jun 2026
include Setting

say "EULER METHOD FOR ODE y'=-0.07(y-20)"
say version
say
call Task 0,100,2,100
call Task 0,100,5,100
call Task 0,100,10,100
call Timer
exit

Task:
-- Euler method
procedure
arg x0,xn,dx,y0
say 'From' x0 'to' xn 'step' dx
say '  x   Calc y      True y    Abs error Rel error'
x=x0; y=y0
do until x > xn
   if x//10 = 0 then
      call Show x,y
   y+=dx*Dy(y); x+=dx
end
say
return

Show:
-- Display a line
procedure
arg xx,yy
yt=True(xx)
say Format(xx,3,0) Format(yy,3,7) Format(yt,3,7),
    Left(Std(Abs(yy-yt)),9) Left(Std(Abs(yy/yt-1)),9)
return

Dy:
-- Differential equation
procedure
arg yy
return -0.07*(yy-20)

True:
-- Real solution
procedure
arg xx
return 20+(100-20)*Exp(-0.07*xx)

include Math
