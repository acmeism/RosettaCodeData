-- 25 Apr 2026
include Setting
numeric digits 16

say "RUNGE-KUTTA METHOD FOR ODE y'=x*Sqrt(y)"
say version
say
call Task 0,10,1,1
call Task 0,10,1/10,1
call Task 0,10,1/100,1
exit

Task:
-- Runge-Kutta method
procedure expose Memo.
arg x0,xn,dx,y0
say 'From' x0 'to' xn 'step' dx
say ' x   Calc y      True y    Abs err    Rel err'
x=x0; y=y0
do until x > xn
   if Integer(x) then
      call Show x,y
   dy1=dx*Dy(x,y)
   dy2=dx*Dy(x+dx/2,y+dy1/2)
   dy3=dx*Dy(x+dx/2,y+dy2/2)
   dy4=dx*Dy(x+dx,y+dy3)
   x+=dx; y+=(dy1+2*dy2+2*dy3+dy4)/6
end
say
return

Show:
-- Display a line
procedure
arg xx,yy
yt=True(xx)
say Format(xx,2,0) Format(yy,3,7) Format(True(xx),3,7),
    Left(Std(Abs(yy-True(xx))),10) Left(Std(Abs(yy/True(xx)-1)),10)
return

Dy:
-- Differential equation
procedure expose Memo.
arg xx,yy
return xx*SqRt(yy)

True:
-- Real solution
procedure
arg xx
return (xx**2+4)**2/16

-- Integer; Std; Sqrt
include Math
