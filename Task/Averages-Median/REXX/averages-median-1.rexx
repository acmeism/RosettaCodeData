-- 6 Jul 2026
include Setting
arg rows
if rows='' then
   rows=100
rows/=1

say 'MEDIAN'
say version
say

say 'Prepare a real array with' rows 'rows...'
call MakeSt 'base.',rows,'r'
if rows<=100 then
   call showst 'base.','Input',10,10
call Timer 'r'

say 'Find median by using Quicksort and take mid element(s)...'
call CopySt 'base.','stem.'
call Timer 'x'
call SortSt 'stem.'
m=rows%2; n=m+1
if Odd(rows) then
   say 'Median =' stem.n
else
   say 'Median =' (stem.n+stem.m)/2
call Timer 'r'

say 'Find median by using Quickselect algorithm...'
call CopySt 'base.','stem.'
call Timer 'x'
say 'Median =' MedianSt('stem.')
call Timer 'r'

say 'Reproduce the other examples...'
v='1 9 2 4'                ;say 'Median' vect2form(v) '=' vect2form(median(v))
v='3 1 4 1 5 9 7 6'        ;say 'Median' vect2form(v) '=' vect2form(median(v))
v='3 4 1 -8.4 7.2 4 1 1.2' ;say 'Median' vect2form(v) '=' vect2form(median(v))
v='-1.2345678E99 2.3E700'  ;say 'Median' vect2form(v) '=' vect2form(median(v))

exit
-- MakeSt ShowSt Timer SortSt MedianSt Odd CopySt
include Math
