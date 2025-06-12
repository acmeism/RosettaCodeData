-- 8 May 2025
include Settings

say 'ARITHMETIC NUMBERS'
say version
say
numeric digits 9
a = 0; c = 0
do i = 1 to 1e6
   if Arithmetic(i) then do
      a = a+1
      if Composite(i) then
         c = c+1
      if a <= 100 then do
         if a = 1 then
            say 'First 100 arithmetic numbers are'
         call Charout ,Right(i,4)
         if a//10 = 0 then
            say
         if a = 100 then
            say
      end
      if a = 100 | a = 1000 | a = 10000 | a = 100000 | a = 1000000 then do
         say 'The' a'th arithmetic number is' i
         say 'Of the first' a 'numbers' c 'are composite'
         say
      end
   end
end
say Format(Time('e'),,3) 'seconds'
return

include Numbers
include Functions
include Special
include Abend
