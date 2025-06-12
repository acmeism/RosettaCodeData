-- 12 Apr 2025
include Settings

call Time('r')
say 'SIEVE OF ERATOSTHENES'
say version
say
call GetBasic 200
call ShowPrimes 200
call GetPrimes 200
call ShowPrimes 200
say Format(Time('e'),,3) 'seconds'; say
exit

GetBasic:
procedure expose prim.
arg xx
say 'Basic sieve up to' xx'...'
call Basic xx
say prim.0 'found'
say
return

Basic:
procedure expose prim. work.
arg xx
work. = 1
do i = 2 while i*i <= xx
   if work.i then do
      do j = i*i by i to xx
         work.j = 0
      end
   end
end
zz = 0
do i = 2 to xx
   if work.i then do
      zz = zz+1; prim.zz = i
   end
end
prim.0 = zz
return zz

GetPrimes:
procedure expose prim. flag.
arg xx
say 'Wheeled sieve up to' xx'...'
call Primes xx
say prim.0 'found'
say
return

ShowPrimes:
procedure expose prim.
arg xx
say 'Primes up to' xx
do i = 1 to prim.0
   call Charout ,right(prim.i,4)
   if i//10 = 0 then
      say
end
say
say
return

include Sequences
include Functions
include Abend
