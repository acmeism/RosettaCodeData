include Settings

say 'POLYNOMIAL HORNER''S RULE - 2 Mar 2025'
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
say Plst2form(x) '| x='y '=' Peval(x,y)+0
return

include Polynomial
include Functions
include Constants
include Abend
