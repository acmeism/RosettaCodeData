-- 24 Aug 2025
include Setting
numeric digits 10

call Time('r')
say 'RAMANUJAN PRIMES'
say version
say
call Primes Floor(4*6e5*Ln(4*6e5))
call Ramanujans
call ShowFirst
do i = 3 to 6
   call ShowNth 10**i
end
say prim.0 'primes processed'
say rama.0 'Ramanujan primes processed'
say Format(Time('e'),,3) 'seconds'
exit

Ramanujans:
procedure expose prim. rama.
rama. = 0; j = 1; rama.1 = 2
do i = 2 to prim.0
   a = prim.i; b = a/2; c = prim.j
   do while c < b
      j = j+1; c = prim.j
   end
   d = i-j+1; rama.d = a; rama.0 = Max(d,rama.0)
end
return 0

ShowFirst:
procedure expose rama.
arg xx
say 'The first 100 Ramanujan primes are...'
do i = 1 to 100
   call Charout ,Right(rama.i,5)
   if i//10 = 0 then
      say
end
say
return

ShowNth:
procedure expose rama.
arg xx
say 'The' xx'th Ramanujan prime is' rama.xx
say
return

include Math
