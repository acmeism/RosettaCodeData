include Settings

say version; say 'Circular primes'; say
call First19
call Next3
call HigherReps
exit

First19:
procedure expose glob. prim.
call Time('r')
numeric digits 10
say 'First 19 circular primes:'
p = Primes(200000)
do i = 1 to p
   a = prim.prime.i
   if Verify(a,'024568','m') > 0 then
      iterate i
   b = a; l = Length(b)
   do l-1
      b = Right(b,l-1)||Left(b,1)
      if b < a then
         iterate i
      if \ IsPrime(b) then
         iterate i
   end
   call Charout ,a' '
end
say
say Format(Time('e'),,3) 'seconds'
say
return

Next3:
procedure expose glob.
call Time('r')
numeric digits 320
say 'Next 3 circular primes:'
do i = 7 to 320
   r = Repunit(i)
   if IsPrime(r) then
      call charout ,'R('i') '
end
say
say Format(Time('e'),,3) 'seconds'
say
return

HigherReps:
procedure expose glob.
call Time('r')
numeric digits 1040
say 'Primality of R(1031):'
if IsPrime(Repunit(1031)) then
   say 'R(1031) is probable prime'
else
   say 'R(1031) is composite'
say Format(Time('e'),,3) 'seconds'
say
return

Repunit:
/* Repeat 1's function */
procedure expose glob.
arg x
/* Formula */
return Copies('1',x)

include Numbers
include Functions
include Abend
