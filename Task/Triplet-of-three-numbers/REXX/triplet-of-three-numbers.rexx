-- 24 Aug 2025
include Setting
arg xx
say 'TRIPLET OF THREE NUMBERS'
say version
say
call Primes 6100
call Task
call Timer
exit

Task:
procedure expose prim. flag.
say 'Triplets below 6000...'
n = 0
do i = 3 to 5999
   a = i-1; b = i+3; c = i+5;
   if flag.a & flag.b & flag.c then do
      n = n+1
      call Charout ,Left(i':' a b c,22)
      if n//5 = 0 then
         say
   end
end
say
say n 'found'
say
return

include Math
