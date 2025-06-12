include Settings

say 'POLYNOMIAL LONG DIVISION - 2 Mar 2025'
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
z = Pdiv(x,y); parse var z q','r
say 'Formula:' Plst2form(x) '/' Plst2form(y) '=' Plst2form(q) 'Rem' Plst2form(r)
say 'Check  :' Plst2form(q) '*' Plst2form(y) '+' Plst2form(r) '=' Plst2form(Padd(Pmul(q,y),r))
say
return

include Polynomial
include Functions
include Abend
