-- 21 Feb 2026
include Setting

say 'MULTI-DIMENSIONAL ARRAY'
say version
say
-- Default value
stem1.=0
-- Incomplete multiplication table
do i = 1 to 5
   do j = 1 to 5
      stem1.i.j=i*j
   end
end
-- Show some results
say 'Multiplication table'
say '2 x 3 =' stem1.2.3
say '5 x 2 =' stem1.5.2
say '3 x 3 =' stem1.3.3
say '4 x 6 =' stem1.4.6
say
-- Indices may have any value, not just numeric.
a="~"; b=" "; c="'"
stem2.a.b.c="Special indices"
say "stem2.~. .' =" stem2.a.b.c
say
-- Dump variable pool
call Showvars
exit

-- Showvars
include Math
