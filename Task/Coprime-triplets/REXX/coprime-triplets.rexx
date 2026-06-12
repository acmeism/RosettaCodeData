-- 23 Aug 2025
include Setting

say 'COPRIME TRIPLETS'
say version
say
numeric digits 3
call GetTriplets
call ShowTriplets
say Format(Time('e'),,3) 'seconds'
exit

GetTriplets:
cp.1 = 1; cp.2 = 2; n = 2
g = 1; h = 2; fp. = 0
do forever
   do i = 3
      if \ Coprime(g,i) then
         iterate i
      if \ Coprime(h,i) then
         iterate i
      if fp.i > 0 then
         iterate i
      leave i
   end
   if i > 49 then
      leave
   fp.i = 1
   n = n+1; cp.n = i
   g = h; h = i
end
return

ShowTriplets:
do i = 1 to n
   call Charout ,Right(cp.i,3)
   if i//10 = 0 then
      say
end
say
return

include Math
