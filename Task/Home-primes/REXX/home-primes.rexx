-- 12 Jun 2026
include Setting
numeric digits 200

say 'HOME PRIMES'
say version
say
do i = 1 to 48
   call Home i
   call Timer 'r'
end
call Home 65
call Timer 'r'
exit

Home:
procedure expose Fact. Glob.
arg xx
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
return

-- FactorS Timer
include Math
