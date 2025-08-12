-- 30 Jul 2025
include Settings

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
say 'Formula:' Lst2FormP(x) '/' Lst2FormP(y) '=' Lst2FormP(q) 'Rem' Lst2FormP(r)
say 'Check  :' Lst2FormP(q) '*' Lst2FormP(y) '+' Lst2FormP(r) '=' Lst2FormP(AddP(MulP(q,y),r))
return

include Math
