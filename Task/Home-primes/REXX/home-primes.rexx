-- 25 Apr 2026
include Setting
numeric digits 200
memo.cache=0

say 'HOME PRIMES'
say version
say
do i = 1 to 48
   call Home i
end
call Home 65
exit

Home:
procedure expose Glob. Fact. Memo. Work.
arg xx
call Timer('x')
if xx = 1 then
   call Charout ,'HP1 = 1'
else do
   yy = xx/1
-- Collect chain
   n = 0
   do while FactorS(yy) > 1
      n = n+1; Work.n = yy; yy=''
      do i = 1 to Fact.0
         yy = yy||Fact.i
      end
   end
-- Show results
   if n = 0 then
      call Charout ,'HP'xx '= '
   else do
      do i = 1 to n
         call Charout ,'HP'Work.i'('n-i+1') = '
      end
   end
   call Charout ,yy
end
say
call Timer
return

-- FactorS; Timer
include Math
