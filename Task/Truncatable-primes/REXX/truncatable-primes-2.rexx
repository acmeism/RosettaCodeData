-- 25 Apr 2025
include Settings
arg xx
say 'TRUNCATABLE PRIMES'
say version
say
call Collect
call Task
call Timer
exit

Collect:
procedure expose prim. flag.
say 'Primes below 1 million...'
say Primes(1E6) 'found'
say
return

Task:
procedure expose prim. flag.
say 'Largest left and right truncatable prime below 1 million...'
l1 = 0; r1 = 0
do i = prim.0 by -1 until l1 > 0 & l2 > 0
   p = prim.i
   if Pos(0,p) > 0 then
      iterate i
   l2 = 1; r2 = 1
   do j = 1 to Length(p)-1
      a = Left(p,j); b = Right(p,j)
      if \ flag.a then
         l2 = 0
      if \ flag.b then
         r2 = 0
   end
   if l1 = 0 & l2 then
      l1 = p
   if r1 = 0 & r2 then
      r1 = p
end
say 'Left' l1
say 'Right' r1
say
return

include Sequences
include Helper
include Numbers
include Functions
include Constants
include Abend
