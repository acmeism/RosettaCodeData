-- 12 Apr 2025
include Settings

call Time('r')
say 'SEXY PRIMES'
say version
say
call GetPrimes 1e6+34
call ShowCount
say Format(Time('e'),,3) 'seconds'
exit

GetPrimes:
procedure expose prim. flag.
arg xx
say 'Get primes up to' xx'...'
call Primes xx
say prim.0 'found'
say
return

ShowCount:
procedure expose prim. flag.
arg xx
sexy. = 0; last. = 0
do i = prim.0 by -1 to 2
   a = prim.i; b = a-6; c = a+6
   if \ flag.b & \ flag.c then do
      sexy.0 = sexy.0+1; d = last.0.0
      if d < 11 then do
         d = d+1; last.0.d = a; last.0.0 = d
      end
      iterate i
   end
   b = a
   do n = 1 to 4
      b = b-6
      if flag.b then do
         sexy.n = sexy.n+1; d = last.n.0
         if d < 5 then do
            d = d+1; last.n.d = b; last.n.0 = d
         end
      end
      else
         iterate i
   end
end
w = 'pairs triplets quadruplets quintuplets'
do i = 1 to 4
   say sexy.i word(w,i) 'ending with'
   do j = 5 by -1 to 1
      a = last.i.j
      if a > 0 then do
         do k = 1 to i+1
            call Charout ,a' '
            a = a+6
         end
         say
      end
   end
   say
end
say sexy.0 'unsexy ending with'
do j = 11 by -1 to 2
   call Charout ,last.0.j' '
end
say
say
return

include Sequences
include Functions
include Abend
