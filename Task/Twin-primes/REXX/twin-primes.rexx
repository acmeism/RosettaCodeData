-- 12 Apr 2025
include Settings

call Time('r')
say 'TWIN PRIMES'
say version
say
call Primes 1e8+10
call ShowPrimes
say Format(Time('e'),,3) 'seconds'
exit

ShowPrimes:
procedure expose prim.
arg xx
say 'Number of twin primes below given threshold...'
n = 0; p = 10
do i = 1 to prim.0
   a = prim.i
   if a > p then do
      say n 'twin primes below' p
      p = p*10
   end
   j = i+1; b = prim.j
   if b-a = 2 then
      n = n+1
end
say
return

include Sequences
include Functions
include Abend
