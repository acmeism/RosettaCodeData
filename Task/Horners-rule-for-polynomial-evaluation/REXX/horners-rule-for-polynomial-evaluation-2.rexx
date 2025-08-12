-- 28 Jul 2025
include Settings

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
say Lst2FormP(x) '| x='y '=' EvalP(x,y)/1
return

include Math
