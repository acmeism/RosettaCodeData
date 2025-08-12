-- 28 Jul 2025
include Settings

say "RUNGE-KUTTA METHOD FOR ODE y'=x*SqRt(y)"
say version
say
numeric digits 9
call Task 0,10,1/10,1
numeric digits 16
call Task 0,10,1/10,1
numeric digits 9
call Task 0,10,1/20,1
numeric digits 16
call Task 0,10,1/20,1
call Timer
exit

Task:
procedure expose Memo.
arg x0,xn,dx,y0
x=x0; y=y0
say 'From' x0 'to' xn 'step' dx 'with' Digits() 'digits'
say ' x       Calc y       True y  Abs error  Rel error'
call Show x,y
do until x >= xn
   dy1=dx*DyDx(x,y)
   dy2=dx*DyDx(x+dx/2,y+dy1/2)
   dy3=dx*DyDx(x+dx/2,y+dy2/2)
   dy4=dx*DyDx(x+dx,y+dy3)
   x=x+dx; y=y+(dy1+2*dy2+2*dy3+dy4)/6
   if Integer(x) then
      call Show x,y
end
say
return

DyDx:
arg xx,yy
return xx*SqRt(yy)

True:
arg xx
return (xx**2+4)**2/16

Show:
arg xx,yy
say Format(xx,2,0) Format(yy,3,8) Format(True(xx),3,8),
    Left(Std(Abs(yy-True(xx))),10) Left(Std(Abs(yy/True(xx)-1)),10)
return

include Math
