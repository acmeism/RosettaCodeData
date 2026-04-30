-- 21 Feb 2026
include Setting

say 'PRIMORIAL NUMBERS'
say version
say
call GetPrimes -9
call Timer 'R'
call ShowFirst10
call Timer 'R'
call GetPrimes -1e6
call Timer 'R'
call UseFloat 1e6
call Timer 'R'
call UseInt 1e4
call Timer 'R'
exit

GetPrimes:
arg x
say 'Get primes up to the' Abs(x)'th:'
numeric digits 10
prim.=0
call Primes(x)
return

ShowFirst10:
say 'The first 10 primorials:'
numeric digits 10
say 'Primorial(0) = 1'
a=1
do i=1 to 9
   a=a*prim.i
   say 'Primorial('i') =' a
end
return

UseFloat:
arg x
say 'Number of digits by real arithmetic and taking exponent:'
numeric digits 10
a=1; e=0
do i=1 to x
   a=a*prim.i; f=Xpon(i)
   if f<>e then do
      say 'Primorial(10^'f') has' Xpon(a)+1 'digits'
      e=f
   end
end
return

UseInt:
arg x
say 'Number of digits by integer arithmetic and taking length:'
select
   when x=10 then
      numeric digits 12
   when x=100 then
      numeric digits 230
   when x=1000 then
      numeric digits 3400
   when x=10000 then
      numeric digits 46000
   when x=100000 then
      numeric digits 570000
   otherwise
      nop
end
a=1; e=0
do i=1 to x
   a=a*prim.i; f=Xpon(i)
   if f<>e then do
      say 'Primorial(10^'f') has' Length(a) 'digits'
      e=f
   end
end
return

-- Primes; Xpon; Timer
include Math
