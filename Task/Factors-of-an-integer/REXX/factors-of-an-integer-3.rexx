include Settings

say version; say 'Factors of an integer'; say
numeric digits 16
parse arg l','h
if l = '' then
   l = 1
if h = '' then
   h = 100
do i = l to h
   f = Divisors(i)
   call Charout ,Right(i,3) 'has' Right(f,2) 'divisors: '
   do j = 1 to f
      call Charout ,divi.divisor.j' '
   end
   say
end
say Format(Time('e'),,3) 'seconds'; say
exit

Divisors:
/* Divisors of an integer */
procedure expose divi.
arg x
/* Init */
divi. = 0
/* Fast values */
if x = 1 then do
   divi.divisor.1 = 1; divi.0 = 1
   return 1
end
/* Euclid's method */
a = 1; divi.left.1 = 1; b = 1; divi.right.1 = x
m = x//2
do j = 2+m by 1+m while j*j < x
   if x//j = 0 then do
      a = a+1; divi.left.a = j; b = b+1; divi.right.b = x%j
   end
end
if j*j = x then do
   a = a+1; divi.left.a = j
end
/* Save in table */
n = 0
do i = 1 to a
   n = n+1; divi.divisor.n = divi.left.i
end
do i = b by -1 to 1
   n = n+1; divi.divisor.n = divi.right.i
end
divi.0 = n
/* Return number of divisors */
return n

include Functions
include Numbers
include Abend
