-- 12 Apr 2025
include Settings
numeric digits 10

call Time('r')
say 'RAMANUJAN TWIN PRIMES'
say version
say
call Primes Floor(4*6e5*Ln(4*6e5))
call Ramanujans
call Twins
say prim.0 'primes processed'
say rama.0 'Ramanujan primes processed'
say twin.0 'Ramanujan twin primes primes found'
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

Twins:
procedure expose rama. twin.
twin. = 0
do i = 2 to 1e6
   i1 = i-1
   if rama.i-rama.i1 = 2 then
      twin.0 = twin.0+1
end
return

include Sequences
include Functions
include Constants
include Abend
