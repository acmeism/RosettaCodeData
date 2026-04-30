-- 4 Mar 2026
include Setting

say 'VECTOR'
say version
say
a = '1 2 3'; b = '3 2 1'; c = 3; d = '4 5'; e = '2 1'
say 'VALUES'
say 'A =' Vect2form(a)
say 'B =' Vect2form(b)
say 'C =' c
say 'D =' Vect2form(d)
say 'E =' Vect2form(e)
say
say 'BASICS'
say 'A+B =' Vect2form(AddV(a,b))
say 'A-B =' Vect2form(SubV(a,b))
say 'A*C =' Vect2form(ScaleV(a,c))
say 'A/C =' Vect2form(ScaleV(a,1/c))
say
say 'BONUS'
say 'Length(D) =' LenV(d)+0
say 'Angle(D)  =' AngV(d)+0
say 'Polar(D)  =' Vect2form(Rec2PolV(d))
say 'Rect(E)   =' Vect2form(Pol2RecV(e))
exit

-- Vect2form; XxxV
include Math
