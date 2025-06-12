-- 22 Mar 2025
include Settings

say 'GOLDBACH''S COMET'
say version
say
numeric digits 7
call GetPrimes
call ShowFirst100
call ShowMillion
exit

GetPrimes:
procedure expose prim. flag.
call Time('r')
say 'Collect Primes up to 1000000...'
call Primes(1e6)
say Time('e')/1 'seconds'
say
return

ShowFirst100:
procedure expose prim. flag.
call Time('r')
say 'First 100 values...'
do i = 4 by 2 to 202
   call Charout ,Right(Goldbach(i),3)
   if i//20 = 2 then
      say
end
say Time('e')/1 'seconds'
say
return

ShowMillion:
procedure expose prim. flag.
call Time('r')
say 'g(1000000)...'
say Goldbach(1e6)
say Time('e')/1 'seconds'
say
return

Goldbach:
procedure expose prim. flag.
arg x
y = 0
do i = 2 to x%2
   if flag.i then do
      j = x-i
      if flag.j then do
         y = y+1
      end
   end
end
return y/1

include Abend
include Functions
include Sequences
