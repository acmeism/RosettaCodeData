-- 16 May 2026
include Setting
numeric digits 16

say 'SUM OF A SERIES'
say version
say
call Task 10
call Task 100
call Task 1000
call Task 10000
call Task 100000
call Task 1000000
call Zeta2
call Timer
exit

Zeta2:
say Zeta(2) '= Zeta(2)'
return

Task:
procedure expose Memo.
arg n
-- Generate array 1,2...n
call MakeSt 'Zeta.','N',n,'A'
-- Map 1/x^2 to all items
call MapSt 'Zeta.','1/(x*x)'
-- Add all items
say SumSt('Zeta.') '= sum' n 'terms'
return

-- Zeta MakeSt MapSt SumSt Timer
include Math
