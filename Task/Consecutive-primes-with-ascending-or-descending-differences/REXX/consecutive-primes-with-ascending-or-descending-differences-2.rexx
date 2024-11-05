call Time('r')
parse version version; say version
glob. = ''; numeric digits 10; t = 1e7
say 'Consecutive primes - Using REXX libraries'
say
call Primes t
call Deltas
call Sequence 'A',t
call Sequence 'D',t
say Format(Time('e'),,3) 'seconds'
exit

Deltas:
/* Calculate deltas between pairs of primes */
procedure expose prim. delta.
delta. = 0
do i = 2 to prim.0
   h = i-1; delta.i = prim.prime.i-prim.prime.h
end
return

Sequence:
/* Find and show longest strict sequence */
procedure expose delta. glob. prim.
arg ad,t
p = prim.0+1
if ad = 'A' then
   delta.p = 0
else
   delta.p = n
d = 0; f = 1; l = 1; len = 0
do i = 2 to p
   if (ad = 'A' & delta.i > d),
   |  (ad = 'D' & delta.i < d) then do
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
if ad = 'A' then
   a = 'ascending'
else
   a = 'descending'
say 'For primes <' t', the longest' a 'sequence was' len 'consecutive primes.'
say 'These are (with differences):'
do i = first to last-1
   j = i+1
   call charout ,prim.prime.i '('delta.j') '
end
call charout ,prim.prime.last
say; say
return

include Sequences
include Functions
