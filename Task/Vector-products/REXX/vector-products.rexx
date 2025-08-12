-- 28 Jul 2025
include Settings

say 'VECTOR PRODUCTS'
say version
say
a = '3 4 5'; b = '4 3 5'; c = '-5 -12 -13'; d = '1 2 3'
say 'VALUES'
say 'A =' Lst2FormV(a)
say 'B =' Lst2FormV(b)
say 'C =' Lst2FormV(c)
say 'D =' Lst2FormV(d)
say
say 'BASICS'
say 'A . B =' DotV(a,b)/1 '= dot product'
say 'A x B =' Lst2FormV(CrossV(a,b)) '= cross product'
say
say 'BONUS'
say 'A . (BxC)     =' ScalTripV(a,b,c)/1 '= scalar triple product'
say 'A x (BxC)     =' Lst2FormV(VectTripV(a,b,c)) '= vector triple product'
say '(AxB) . (CxD) =' ScalQuadV(a,b,c,d)/1 '= scalar quadruple product'
say '(AxB) x (CxD) =' Lst2FormV(VectQuadV(a,b,c,d)) '= vector quadruple product'
exit

include Math
