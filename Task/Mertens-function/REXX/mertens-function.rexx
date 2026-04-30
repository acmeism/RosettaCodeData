-- 3 Mar 2026
include Setting
arg xx
if xx = '' then
   xx = 99

say 'MERTENS FUNCTION'
say version
say
call Tasks1 xx
call Timer 'R'
call Tasks2 xx
call Timer 'R'
call Tasks3 xx
call Timer 'R'
exit

Tasks1:
procedure expose squa. memo.
arg xx
say 'Tasks using Sieve...'
call Squarefrees 2*xx
if xx < 100 then
   say 'M1 thru M'xx
e = 0; o = 0; a = 0; b = 0
n = 1; s = squa.1; p = s
do i = 1 to xx
   if s <= i then do
      if s = 1 then
         f = 0
      else
         f = Factors(s)
      e = e+Even(f); o = o+Odd(f); m = e-o
      n = n+1; s = squa.n
   end
   if xx < 100 & i < 100 then do
      call Charout ,Right(m,3)
      if i//10 = 0 then
         say
   end
   if m = 0 then do
      a = a+1
      if p <> 0 then
         b = b + 1
   end
   p = m
end
say
say 'M1 thru M'xx 'equals zero' a 'times'
say 'M1 thru M'xx 'crosses zero' b 'times'
return

Tasks2:
procedure expose squa. memo.
arg xx
say 'Tasks using Moebius function...'
if xx < 100 then
   say 'M1 thru M'xx
e = 0; o = 0; a = 0; b = 0
s = 0
do i = 1 to xx
   s = s+Moebius(i)
   if xx < 100 & i < 100 then do
      call Charout ,Right(s,3)
      if i//10 = 0 then
         say
   end
   if s = 0 then do
      a = a+1
      if p <> 0 then
         b = b + 1
   end
   p = s
end
say
say 'M1 thru M'xx 'equals zero' a 'times'
say 'M1 thru M'xx 'crosses zero' b 'times'
return

Tasks3:
procedure expose squa. memo.
arg xx
say 'Tasks using Squarefree function...'
if xx < 100 then
   say 'M1 thru M'xx
e = 0; o = 0; a = 0; b = 0
do s = 1 to xx
   if Squarefree(s) then do
      if s = 1 then
         f = 0
      else
         f = Factors(s)
      e = e+Even(f); o = o+Odd(f); m = e-o
   end
   if xx < 100 & s < 100 then do
      call Charout ,Right(m,3)
      if s//10 = 0 then
         say
   end
   if m = 0 then do
      a = a+1
      if p <> 0 then
         b = b + 1
   end
   p = m
end
say
say 'M1 thru M'xx 'equals zero' a 'times'
say 'M1 thru M'xx 'crosses zero' b 'times'
return

-- Squarefrees; Factors; Even; Odd; Moebius; Timer
include Math
