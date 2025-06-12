-- 8 May 2025
include Settings

say 'VECTOR PRODUCTS'
say version
say
a = '3 4 5'; b = '4 3 5'; c = '-5 -12 -13'; d = '1 2 3'
say 'VALUES'
say 'A =' Vlst2Form(a)
say 'B =' Vlst2Form(b)
say 'C =' Vlst2Form(c)
say 'D =' Vlst2Form(d)
say
say 'BASICS'
say 'A . B =' Vdot(a,b)/1
say 'A x B =' Vlst2Form(Vcross(a,b))
say
say 'BONUS'
say 'A . (BxC)     =' VscalTrip(a,b,c)/1
say 'A x (BxC)     =' Vlst2Form(VvectTrip(a,b,c))
say '(AxB) . (CxD) =' VscalQuad(a,b,c,d)/1
say '(AxB) x (CxD) =' Vlst2Form(VvectQuad(a,b,c,d))
exit

include Vector
include Functions
include Constants
include Abend
