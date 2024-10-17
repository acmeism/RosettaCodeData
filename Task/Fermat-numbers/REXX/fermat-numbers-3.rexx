include Settings

numeric digits 200
say 'Fermat numbers - Using REXX libraries'
parse version version; say version; say
do i = 0 to 9
   p = 2**(2**i)+1; l = Length(p)
   say 'Fermat number' i',' p',' l 'digits'
   if i < 7 then do
      f = Factors(p)
      if f = 1 then
         say 'is prime'
      else do
         call Charout ,'has factors '
         do j = 1 to f
            call Charout, fact.factor.j' '
         end
         say
      end
   end
   else do
      if IsPrime(p) then
         say 'is prime'
      else
         say 'is composite, but could not be factorized'
   end
   say
end
say Format(Time('e'),,3) 'seconds'; say
exit

include Functions
include Numbers
include Abend
