parse Version version
say version; say 'Arithmetic numbers'; say
Call time 'R'
numeric digits 9
a = 0; c = 0
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

Arithmetic:
/* Is a number arithmetic? function */
procedure expose divi.
arg x
/* Cf definition */
s = Sigma(x)
if Whole(s/divi.0) then
   return 1
else
   return 0

Sigma:
/* Sigma = Sum of all divisors of x including 1 and x */
procedure expose divi.
arg xx
/* Fast values */
if xx = 1 then do
   divi.0 = 1
   return 1
end
/* Euclid's method */
m = xx//2; yy = 1+xx; n = 2
do j = 2+m by 1+m while j*j < xx
   if xx//j = 0 then do
      yy = yy+j+xx%j; n = n+2
   end
end
if j*j = xx then do
   yy = yy+j; n = n+1
end
/* Store number of divisors */
divi.0 = n
/* Return sum */
return yy

Whole:
/* Is a number integer? */
procedure
arg xx
/* Formula */
return Datatype(xx,'w')
