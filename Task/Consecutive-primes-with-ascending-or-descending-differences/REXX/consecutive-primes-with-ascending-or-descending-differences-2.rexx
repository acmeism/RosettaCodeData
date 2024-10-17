call Time('r')
parse version version; say version
glob. = ''; numeric digits 10
say 'Consecutive primes - Using REXX libraries'
say
call CollectPrimes
call CalculateDeltas
call Sequence 'A'
call Show 'A'
call Sequence 'D'
call Show 'D'
say Format(Time('e'),,3) 'seconds'
exit

CollectPrimes:
/* Collect all primes */
n = 1e6; p = Primes(n)
return

CalculateDeltas:
/* Calculate deltas between pairs of primes */
delta. = 0
do i = 2 to p
   h = i-1; delta.i = prim.prime.i-prim.prime.h
end
p = p+1
return

Sequence:
/* Find longest strict sequence */
arg seq
if seq = 'A' then
   delta.p = 0
else
   delta.p = n
d = 0; f = 1; l = 1; len = 0
do i = 2 to p
   if (seq = 'A' & delta.i > d),
   |  (seq = 'D' & delta.i < d) then do
      d = delta.i; l = i
   end
   else do
      a = l-f+1
      if a > len then do
         first = f; last = l; len = a
      end
      f = i-1; l = i; d = delta.i
   end
end
return

Show:
/* Show results */
arg seq
if seq = 'A' then
   a = 'ascending'
else
   a = 'descending'
say 'For primes <' n', the longest' a 'sequence was' len 'consecutive primes.'
say 'The first one (with differences) is:'
do i = first to last-1
   j = i+1
   call charout ,prim.prime.i '('delta.j') '
end
call charout ,prim.prime.last
say; say
return

include Numbers
include Functions
