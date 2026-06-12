numeric digits 15

say 'EXTREME PRIMES'
say .local~version
say
say 'Sieve primes up to 50 million...'
say PrimeS(5e7) 'found'
call Timer('r')
call Task
call Timer('r')
exit

Task:
procedure expose Prim. Flag.
say Right('Seq',6) Right('Prime',8) Right('Sum',14)
s=0; n=0; t=0
pn=stemget('prim.',0)
do i=1 to pn until n=100000
   p=stemget('prim.',i); s+=p; t+=1
   if Prime(s) then do
      n+=1
      if n<=30 | (n<10000 & n//1000=0) | n//10000=0 then
         say Right(n,6) Right(p,8) Right(s,14)
   end
end
say t 'primality tests performed'
return

::requires math
