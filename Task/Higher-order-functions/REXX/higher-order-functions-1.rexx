include Settings

Main:
say version; say 'Higher-order functions'; say
call Calculate '1/x',6
call Calculate 'Sqrt(x)',2
call Calculate 'Sin(x)',1
call Calculate 'Cos(x)',2
call Calculate 'Tan(x)',3
call Calculate 'Sin(x)/Cos(x)-Tan(x)',1
call Calculate 'x**2-3*x+Arcsin(x)-Sinh(x)/x-Pi()+E()',1/3
exit

Calculate:
procedure
parse arg ff,xx
say ff 'for x='xx 'makes' Evaluate(ff,xx)+0
return

Evaluate:
procedure
parse arg f,x
interpret 'return' f

include Functions
include Constants
include Abend
