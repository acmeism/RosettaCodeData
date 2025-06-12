-- 8 May 2025
include Settings
numeric digits 10
arg xx
if xx = '' then
   xx = 1e6

say 'PRIME CONSPIRACY'
say version
say
call GetPrimes xx
call CollectStats
call ShowStats
exit

GetPrimes:
call Time('r')
arg xx
say 'Analysis for first' xx 'primes follows'
say
say 'Get primes...'
call Primes -xx; prim.0 = xx
say xx 'primes found'
say Format(Time('e'),,3) 'seconds'; say
return

CollectStats:
call Time('r')
say 'Collect statistics...'
tran. = 0
a = Right(prim.1,1); tran.2 = 1
do i = 2 to prim.0
   b = Right(prim.i,1); d = Right(prim.i,2)+0
   tran.a.b = tran.a.b+1; tran.d = tran.d+1
   a = b
end
say Format(Time('e'),,3) 'seconds'; say
return

ShowStats:
say 'Transition count...'
do i = 1 to 9
   do j = 1 to 9
      if tran.i.j > 0 then do
         say 'Transition' i'->'j 'Count' Right(tran.i.j,5) 'Freq' Format(100*tran.i.j/(prim.0-1),2,3)'%'
      end
   end
end
say
say 'Last 2 digits count...'
do i = 1 to 99
   if tran.i > 0 then do
      if i < 10 then
         d = '0'i
      else
         d = i
      say 'Digits' d 'Count' Right(tran.i,6) 'Freq' Format(100*tran.i/prim.0,2,3)'%'
   end
end
say
return

include Sequences
include Functions
include Special
include Constants
include Abend
