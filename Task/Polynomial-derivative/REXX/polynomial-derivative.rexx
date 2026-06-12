-- 21 Feb 2026
include Setting

say 'POLYNOMIAL DERIVATIVE'
say version
say
call Derive '5'
call Derive '-3 4'
call Derive '5 6 -1'
call Derive '1 -2 3 -4'
call Derive '-1 -1 0 1 1'
exit

Derive:
arg x
say '('Poly2form(x)')''' '=' Poly2form(DifP(x))
return

-- DifP; Poly2form
include Math
