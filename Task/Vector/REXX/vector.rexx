-- 19 May 2025
include Settings

say 'VECTOR'
say version
say
a = '1 2 3'; b = '3 2 1'; c = 3; d = '4 5'; e = '2 1'
say 'VALUES'
say 'A =' Vlst2Form(a)
say 'B =' Vlst2Form(b)
say 'C =' c
say 'D =' Vlst2Form(d)
say 'E =' Vlst2Form(e)
say
say 'BASICS'
say 'A+B =' Vlst2Form(Vadd(a,b))
say 'A-B =' Vlst2Form(Vsub(a,b))
say 'A*C =' Vlst2Form(Vmul(a,c))
say 'A/C =' Vlst2Form(Vdiv(a,c))
say
say 'BONUS'
say 'Length(D) =' Vlen(d)+0
say 'Angle(D)  =' Vang(d)+0
say 'Polar(D)  =' Vlst2Form(Vrec2Pol(d))
say 'Rect(E)   =' Vlst2Form(Vpol2Rec(e))
exit

include Vector
include Functions
include Constants
include Abend
