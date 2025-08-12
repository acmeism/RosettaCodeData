-- 28 Jul 2025
include Settings

say 'CIRCULAR PRIMES'
say version
say
call First19
call Next3
call HigherReps
exit

First19:
procedure expose Memo. prim.
call Time('r')
numeric digits 10
say 'First 19 circular primes:'
p = Primes(200000)
do i = 1 to p
   a = prim.i
   if Verify(a,'024568','m') > 0 then
      iterate i
   b = a; l = Length(b)
   do l-1
      b = Right(b,l-1)||Left(b,1)
      if b < a then
         iterate i
      if \ Prime(b) then
         iterate i
   end
   call Charout ,a' '
end
say
say Format(Time('e'),,3) 'seconds'
say
return

Next3:
procedure expose Memo.
call Time('r')
numeric digits 320
say 'Next 3 circular primes:'
do i = 7 to 320
   r = Repunit(i)
   if Prime(r) then
      call Charout ,'R('i') '
end
say
say Format(Time('e'),,3) 'seconds'
say
return

HigherReps:
procedure expose Memo.
call Time('r')
numeric digits 1040
say 'Primality of R(1031):'
if Prime(Repunit(1031)) then
   say 'R(1031) is probable prime'
else
   say 'R(1031) is composite'
say Format(Time('e'),,3) 'seconds'
say
return

include Math
