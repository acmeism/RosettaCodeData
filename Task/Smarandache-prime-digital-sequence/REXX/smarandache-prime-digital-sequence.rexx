-- 12 Apr 2025
include Settings
numeric digits 12

call Time('r')
say 'SMARANDACHE PRIME-DIGITAL SEQUENCE'
say version
say
call Task1
call Task2
say Format(Time('e'),,3) 'seconds'
exit

Task1:
procedure expose prim.
say 'First 25 SPDS primes...'
n = 0
do i = 1 until n = 25
   if PrimeDigits(i) then do
      if Prime(i) then do
         n = n+1
         call Charout ,Right(i,9)
         if n //10 = 0 then
            say
      end
   end
end
say
say
return

Task2:
procedure expose prim.
say 'Higher in the sequence...'
n = 4; t = 0
do i = 23 by 2 until n = 23e3
   if Pos(Right(i,1),37) > 0 then do
      if PrimeDigits(i) then do
         t = t+1
         if Prime(i) then do
            n = n+1
            if n//1000 = 0 then do
               say n'th is' i
            end
         end
      end
   end
end
say t 'prime tests performed'
say
return

PrimeDigits:
procedure
arg xx
a = Verify(xx,2357)
if a > 0 then
   return 0
else
   return 1

include Numbers
include Sequences
include Functions
include Abend
