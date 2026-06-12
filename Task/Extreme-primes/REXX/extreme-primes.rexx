-- 15 Nov 2025
include Setting
numeric digits 15

say 'EXTREME PRIMES'
say version
say
say 'Sieve primes up to 50 million...'
say PrimeS(5e7) 'found'
call Timer('r')
call Task
call Timer('r')
exit

Task:
procedure expose Prim.
say Right('Seq',6) Right('Prime',8) Right('Sum',14)
s=0; n=0; t=0
do i=1 to Prim.0 until n=100000
   p=Prim.i; s+=p; t+=1
   if Prime(s) then do
      n+=1
      if n<=30 | (n<10000 & n//1000=0) | n//10000=0 then
         say Right(n,6) Right(p,8) Right(s,14)
   end
end
say t 'primality tests performed'
return

-- Prime (is prime?)
include Ntheory
-- PrimeS (get all primes up to threshold)
include Sequence
-- Timer
include Timer
