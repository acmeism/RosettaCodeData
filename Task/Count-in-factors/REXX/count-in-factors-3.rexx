call Time('r')
say 'Count in factors - Using REXX libraries'
parse version version; say version
say
numeric digits 16
call CountFactors 1,20
call CountFactors 1e3,1e3+20
call CountFactors 1e6,1e6+20
call CountFactors 1e9,1e9+20
call CountFactors 1e12,1e12+20
call CountFactors 1e15,1e15+20
say Format(Time('e'),,3) 'seconds'
exit

CountFactors:
arg x,y
say 'Factorization of the numbers' x 'to' y
say
do i = x to y
   f = Factors(i)
   if i = 1 then
      s = '1 = 1'
   else
      s = i '='
   do j = 1 to f
      s = s fact.factor.j
      if j < f then
         s = s 'x'
   end
   say s
end
say
return

include Numbers
include Functions
