-- 8 May 2025
include Settings

say 'UNTOUCHABLE NUMBERS'
say version
say
xx = 2000; yy = 8*xx
call GetPrimes yy
call MarkTouchables xx,yy
call DisplayList xx
xx = 100000; yy = 14*xx
call GetPrimes yy
call MarkTouchables xx,yy
call DisplayCount xx
call Timer
exit

GetPrimes:
procedure expose prim. flag.
arg yy
say 'Get primes below' yy'...'
say Primes(yy) 'found'
say
return

MarkTouchables:
procedure expose touc. prim. flag.
arg xx,yy
say 'Mark touchable numbers below' xx'...'
touc. = 0
do p = 1 to prim.0
   a = prim.p+1; touc.a = 1
   a = prim.p+3; touc.a = 1
end
touc.5 = 0
do j = 2 for yy
   if flag.j then
      iterate j
   y = Aliquot(j)
   if y <= xx then
      touc.y = 1
end
say 'Done'
say
return

DisplayList:
procedure expose touc.
arg xx
say 'Show untouchable numbers below' xx'...'
n = 2
call Charout ,Right(2,5) Right(5,4)
do i = 6 by 2 to xx
   if touc.i then
      iterate i
   n = n+1
   call Charout ,Right(i,5)
   if n//10 = 0 then
      say
end
say
say n 'found'
say
return

DisplayCount:
procedure expose touc.
arg xx
say 'Show untouchable number count...'
n = 2; a = 10
do i = 6 by 2 to xx+10
   if touc.i then
      iterate i
   if i > a then do
      say right(n,5) 'below' right(a,6)
      a = a*10
   end
   n = n+1
end
say
return

include Sequences
include Helper
include Functions
include Special
include Constants
include Abend
