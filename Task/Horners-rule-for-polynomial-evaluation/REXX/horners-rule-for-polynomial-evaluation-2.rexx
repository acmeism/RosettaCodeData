-- 21 Feb 2026
include Setting

say 'POLYNOMIAL HORNER''S RULE'
say version
say
call Evaluate '6 -4 7 -19',3
call Evaluate '2',4
call Evaluate '2 3',0
call Evaluate '2 0 -3 0 4',5
call Evaluate '1 2 3',Pi()+0
exit

Evaluate:
arg x,y
say Poly2form(x) '| x='y '=' EvalP(x,y)/1
return

-- Poly2form; EvalP; Pi
include Math
