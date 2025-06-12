-- 8 May 2025
include Settings

say 'ABUNDANT, DEFICIENT AND PERFECT NUMBER CLASSIFICATIONS'
say version
say
parse value 0 0 0 with a p d
do x = 1 to 20000
   sum = Aliquot(x)
   select
      when x < sum then
         a = a+1
      when x = sum then
         p = p+1
      otherwise
         d = d+1
   end
end

say 'In the range 1 - 20000'
say Format(a,5) 'numbers are abundant  '
say Format(p,5) 'numbers are perfect   '
say Format(d,5) 'numbers are deficient '
say Time('e') 'seconds'
exit

include Numbers
include Functions
include Special
include Abend
