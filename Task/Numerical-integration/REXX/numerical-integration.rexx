-- 8 Jun 2025
include Settings
arg digs
if digs = '' then
   digs=9
numeric digits digs

say 'NUMERICAL INTEGRATION: COMPARE 5 METHODS'
say version
say
w=Digits()+2
say Left('Function',11) Left( 'Range',w+4) Left('Method',9) Left( 'Steps',7),
    Left('Result',w) Left('True',w) ' Error'
say
call Task 'x**3',       0, 1,      100,     1/4
call Task '1/x',        1, 100,    1000,    Ln(100)/1
call Task 'x',          0, 5000,   1000000, 12500000
call Task 'x',          0, 5000,   4,       12500000
call Task '4/(x**2+1)', 0, 1,      100,     Pi()/1
call Task '4/(x**2+1)', 0, 1,      1000,    Pi()/1
call Task 'Sin(x)',     0, Pi()/1, 100,     2
call Task 'Sin(x)',     0, Pi()/1, 10000,   2
call Task 'Cos(x)',     0, Pi()/1, 100,     0
call Task 'Cos(x)',     0, Pi()/1, 10000,   0
call Task 'Tan(x)',     0, Pi()/1, 100,     0
call Task 'Tan(x)',     0, Pi()/1, 10000,   0
call Task 'Exp(x)',    -3, 3,      100,     Exp(3)-Exp(-3)
call Task 'Exp(x)',    -3, 3,      10000,   Exp(3)-Exp(-3)
call Task 'Gamma(x)',   1, 8,      100,     2603.238829328642145
call Task 'Gamma(x)',   1, 8,      10000,   2603.238829328642145
call Timer
exit

Task:
procedure expose glob.
arg ff,aa,bb,steps,true
w=Digits()+2
res=LeftRect(ff,aa,bb,steps); diff=res-true
say Left(ff,11) Left(aa '-' bb,w+4) Left('LeftRect',9) Left(steps,7),
    Left(Std(res),w) Left(true,w) Format(diff,2,4,,0)
res=MidRect(ff,aa,bb,steps); diff=res-true
say Left(ff,11) Left(aa '-' bb,w+4) Left('MidRect',9) Left(steps,7),
    Left(Std(res),w) Left(true,w) Format(diff,2,4,,0)
res=RightRect(ff,aa,bb,steps); diff=res-true
say Left(ff,11) Left(aa '-' bb,w+4) Left('RightRect',9) Left(steps,7),
    Left(Std(res),w) Left(true,w) Format(diff,2,4,,0)
res=Trapezoid(ff,aa,bb,steps); diff=res-true
say Left(ff,11) Left(aa '-' bb,w+4) Left('Trapezoid',9) Left(steps,7),
    Left(Std(res),w) Left(true,w) Format(diff,2,4,,0)
res=Simpson(ff,aa,bb,steps); diff=res-true
say Left(ff,11) Left(aa '-' bb,w+4) Left('Simpson',9) Left(steps,7),
    Left(Std(res),w) Left(true,w) Format(diff,2,4,,0)
say
return

LeftRect:
procedure expose glob.
arg ff,aa,bb,steps
h=(bb-aa)/steps; s=0
do n = 0 to steps-1
   s=s+Eval(ff,aa+n*h)
end
return s*h

MidRect:
procedure expose glob.
arg ff,aa,bb,steps
h=(bb-aa)/steps; s=0; aa=aa-h/2
do n = 1 to steps
   s=s+Eval(ff,aa+n*h)
end
return s*h

RightRect:
procedure expose glob.
arg ff,aa,bb,steps
h=(bb-aa)/steps; s=0
do n = 1 to steps
   s=s+Eval(ff,aa+n*h)
end
return s*h

Trapezoid:
procedure expose glob.
arg ff,aa,bb,steps
h=(bb-aa)/steps; s=0.5*(Eval(ff,aa)+Eval(ff,bb))
do n = 1 to steps-1
   s=s+Eval(ff,aa+n*h)
end
return s*h

Simpson:
procedure expose glob.
arg ff,aa,bb,steps
h=(bb-aa)/steps; s=Eval(ff,aa)+Eval(ff,bb)
do n = 1 by 2 to steps-1
   s=s+4*Eval(ff,aa+n*h)
end
do n = 2 by 2 to steps-1
   s=s+2*Eval(ff,aa+n*h)
end
return s*h/3

include Functions
include Special
include Constants
include Helper
include Abend
