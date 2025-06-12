-- 22 Mar 2025
include Settings

say 'CONSECUTIVE PRIMES'
say version
say
numeric digits 10; t = 1e7
call Primes t
call Deltas
call Sequence 'A',t
call Sequence 'D',t
say Format(Time('e'),,3) 'seconds'
exit

Deltas:
-- Calculate deltas between pairs of primes
procedure expose prim. delt.
delt. = 0
do i = 2 to prim.0
   h = i-1; delt.i = prim.i-prim.h
end
return

Sequence:
-- Find and show longest strict sequence
procedure expose delt. prim.
arg ad,t
p = prim.0+1
if ad = 'A' then
   delt.p = 0
else
   delt.p = t
d = 0; f = 1; l = 1; len = 0
do i = 2 to p
   if (ad = 'A' & delt.i > d),
   |  (ad = 'D' & delt.i < d) then do
      d = delt.i; l = i
   end
   else do
      a = l-f+1
      if a > len then do
         first = f; last = l; len = a
      end
      f = i-1; l = i; d = delt.i
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
   call charout ,prim.i '('delt.j') '
end
call charout ,prim.last
say; say
return

include Sequences
include Functions
include Abend
