-- 13 Jun 2026
include Setting

say 'PARTIAL FUNCTION APPLICATION'
say version
say 'F1 doubles, F2 squares'
say
-- List of low integers
list=''
do i = 0 to 3
   list=Strip(list i)
end i
-- Apply F1 and F2
call Fs 'F1',list
say 'For F1: Sequence =' list', Result =' result
call Fs 'F2',list
say 'For F2: Sequence =' list', Result =' result
-- List of low even integers
list=''
do i = 2 by 2 to 8
   list=Strip(list i)
end i
-- Apply F1 and F2
call Fs 'F1',list
say 'For F1: Sequence =' list', Result =' result
call Fs 'F2',list
say 'For F2: Sequence =' list', Result =' result
exit

Fs:
-- Partial function application
-- Mimics 'map' operation
procedure
arg function,list
dd=''
do w = 1 for Words(list)
   z=Word(list,w)
   interpret 'dd=dd' function'('z')'
end w
return Strip(dd)

F1:
-- Double
return arg(1)*2

F2:
-- Square
return arg(1)**2

include Math
