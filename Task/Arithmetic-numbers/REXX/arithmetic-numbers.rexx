include Settings

say version; say 'Arithmetic numbers'; say
numeric digits 9
divi. = 0; a = 0; c = 0
do i = 1
/* Is the number arithmetic? */
   if Arithmetic(i) then do
      a = a+1
/* Is the number composite? */
      if divi.0 > 2 then
         c = c+1
/* Output control */
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
/* Max 1m, higher takes too long */
      if a = 1000000 then
         leave
   end
end
say Format(Time('e'),,3) 'seconds'
exit

include Numbers
include Functions
include Abend
