include Settings

say version; say 'k-Almost primes'; say
arg n k m
say 'Direct approach using Factors'
numeric digits 16
if n = '' then
   n = 10
if k = '' then
   k = 5
/* Maximum number to examine */
if m = '' then
   m = 180
call Time('r')
/* Collect almost primes */
ap. = 0
do i = 2 to m
   f = Factors(i); ap.f.0 = ap.f.0+1
   ap = ap.f.0; ap.f.ap = i
end
/* Show results */
do i = 1 to k
   call Charout ,'k='i': '
   do j = 1 to n
      if ap.i.j > 0 then do
         call Charout ,ap.i.j' '
      end
   end
   say
end
say Format(Time('e'),,3) 'seconds'
exit

include Numbers
include Sequences
include Functions
include Abend
