-- 28 Jul 2025
include Settings
numeric digits 100
arg xx
if xx = '' then
   xx = 30

say 'YELLOWSTONE SEQUENCE'
say version
say
call GetYellow xx
call DisplayList xx
call Timer
exit

GetYellow:
procedure expose yell. work. Memo.
arg xx
say 'Get yellowstones...'
yell. = 0; work. = 0; n = 0
do i = 1 until n = xx
   p = n-1
   if i < 5 then do
      n = n+1; yell.n = i; work.n = i; work.i = 1
      iterate i
   end
   do j = 1
      if work.j then
         iterate j
      if Gcd(j,yell.p) = 1 then
         iterate j
      if Gcd(j,yell.n) <> 1 then
         iterate j
      n = n+1; yell.n = j; work.j = 1
      leave j
   end
end
say
return xx

DisplayList:
procedure expose yell.
arg xx
say 'Yellowstone sequence...'
do i = 1 to xx
   call Charout ,Right(yell.i,5)
   if i//10 = 0 then
      say
end
say
return

include Math
