include Settings

say 'Primorial numbers'
parse version version; say version; say
call GetPrimes -9
call ShowFirst10
call GetPrimes -1e6
call UseFloat 1e6
call UseLog 1e6
call UseInt 1e4
exit

GetPrimes:
arg x
call Time('r')
say 'Get primes up to the' Abs(x)'th:'
numeric digits 10
prim. = 0
call Primes(x)
say Format(Time('e'),,3) 'seconds'; say
return

ShowFirst10:
call Time('r')
say 'The first 10 primorials:'
numeric digits 10
say 'Primorial(0) = 1'
a = 1
do i = 1 to 9
   a = a*prim.prime.i
   say 'Primorial('i') =' a
end
say Format(Time('e'),,3) 'seconds'; say
return

UseFloat:
arg x
call Time('r')
say 'Number of digits by real arithmetic and taking exponent:'
numeric digits 10
a = 1; e = 0
do i = 1 to x
   a = a*prim.prime.i
   f = Xpon(i)
   if f <> e then do
      say 'Primorial(10^'f') has' Xpon(a)+1 'digits'
      e = f
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

UseLog:
arg x
call Time('r')
say 'Number of digits by summing log10:'
numeric digits 10
a = 0; e = 0
do i = 1 to x
   a = a+Log10(prim.prime.i)
   f = Xpon(i)
   if f <> e then do
      say 'Primorial(10^'f') has' Trunc(a)+1 'digits'
      e = f
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

UseInt:
arg x
call Time('r')
say 'Number of digits by integer arithmetic and taking length:'
select
   when x = 10 then
      numeric digits 12
   when x = 100 then
      numeric digits 230
   when x = 1000 then
      numeric digits 3400
   when x = 10000 then
      numeric digits 46000
   when x = 100000 then
      numeric digits 570000
   otherwise
      nop
end
a = 1; e = 0
do i = 1 to x
   a = a*prim.prime.i
   f = Xpon(i)
   if f <> e then do
      say 'Primorial(10^'f') has' Length(a) 'digits'
      e = f
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

include Numbers
include Functions
include Sequences
include Constants
include Abend
