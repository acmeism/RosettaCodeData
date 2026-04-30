-- 25 Apr 2026
include Setting

say 'CIRCULAR PRIMES'
say version
say
call First19
call Timer 'r'
call Next3
call Timer 'r'
call Rep1031
call Timer 'r'
exit

First19:
procedure expose Memo. Prim.
numeric digits 10
say 'First 19 circular primes:'
p = Primes(200000)
do i = 1 to p
   a = Prim.i
   if a>10 then
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
return

Next3:
procedure expose Memo.
numeric digits 1000
say 'Next 3 circular primes:'
do i = 7 to 320
   r = Repunit(i)
   if Prime(r) then
      call Charout ,'R('i') '
end
say
return

Rep1031:
procedure expose Memo.
call Time('r')
numeric digits 10000
say 'Primality of R(1031):'
if Prime(Repunit(1031)) then
   say 'R(1031) is probably prime'
else
   say 'R(1031) is composite'
return

-- Primes Prime Repunit Timer
include Math
