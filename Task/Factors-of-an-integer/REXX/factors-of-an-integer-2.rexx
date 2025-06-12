-- 22 Mar 2025
include Settings

say 'FACTORS OF AN INTEGER'
say version
say
numeric digits 16
parse arg l','h
if l = '' then
   l = 1
if h = '' then
   h = 100
do i = l to h
   f = Divisors(i)
   call Charout ,Right(i,3) 'has' Right(f,2) 'divisors: '
   do j = 1 to f
      call Charout ,divi.j' '
   end
   say
end
say Format(Time('e'),,3) 'seconds'; say
exit

include Functions
include Sequences
include Abend
