-- 21 Feb 2026
include Setting

say 'POLYNOMIAL LONG DIVISION'
say version
say
call Divide '1 -12 0 -42','1 -3'
call Divide '5 4 1','2 3'
call Divide '5 0 0 4 0 0 0 0 0 0 1','2 0 2 0 3'
call Divide '2 -24 2 -108 3 -120 0 -126','2 0 2 0 3'
call Divide '1 2','1 2 3'
call Divide '1 2 3','1 2 3'
call Divide '1 2 3','2'
call Divide '2 0 0','1 0'
exit

Divide:
arg x,y
z = DivP(x,y); parse var z q','r
say 'Formula:' Poly2form(x) '/' Poly2form(y) '=' Poly2form(q) 'Rem' Poly2form(r)
say 'Check  :' Poly2form(q) '*' Poly2form(y) '+' Poly2form(r) '=' Poly2form(AddP(MulP(q,y),r))
return

-- AddP; MulP; DivP; Poly2form
include Math
