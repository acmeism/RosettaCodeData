-- 28 Jul 2025
include Settings

say 'VECTOR'
say version
say
a = '1 2 3'; b = '3 2 1'; c = 3; d = '4 5'; e = '2 1'
say 'VALUES'
say 'A =' Lst2FormV(a)
say 'B =' Lst2FormV(b)
say 'C =' c
say 'D =' Lst2FormV(d)
say 'E =' Lst2FormV(e)
say
say 'BASICS'
say 'A+B =' Lst2FormV(AddV(a,b))
say 'A-B =' Lst2FormV(SubV(a,b))
say 'A*C =' Lst2FormV(ScaleV(a,c))
say 'A/C =' Lst2FormV(ScaleV(a,1/c))
say
say 'BONUS'
say 'Length(D) =' LenV(d)+0
say 'Angle(D)  =' AngV(d)+0
say 'Polar(D)  =' Lst2FormV(Rec2PolV(d))
say 'Rect(E)   =' Lst2FormV(Pol2RecV(e))
exit

include Math
