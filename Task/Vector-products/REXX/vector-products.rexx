-- 4 Mar 2026
include Setting

say 'VECTOR PRODUCTS'
say version
say
a = '3 4 5'; b = '4 3 5'; c = '-5 -12 -13'; d = '1 2 3'
say 'VALUES'
say 'A =' Vect2form(a)
say 'B =' Vect2form(b)
say 'C =' Vect2form(c)
say 'D =' Vect2form(d)
say
say 'BASIC'
say 'A . B =' DotV(a,b)/1 '= dot product'
say 'A x B =' Vect2form(CrossV(a,b)) '= cross product'
say
say 'BONUS'
say 'A . (BxC)     =' ScalTripV(a,b,c)/1 '= scalar triple product'
say 'A x (BxC)     =' Vect2form(VectTripV(a,b,c)) '= vector triple product'
say '(AxB) . (CxD) =' ScalQuadV(a,b,c,d)/1 '= scalar quadruple product'
say '(AxB) x (CxD) =' Vect2form(VectQuadV(a,b,c,d)) '= vector quadruple product'
exit

-- Vect2form; XxxV
include Math
