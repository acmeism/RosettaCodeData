include Settings

say version; say 'Euclid-Mullin sequence'; say
numeric digits 100
call Task 16
say Format(Time('e'),,3) 'seconds'
exit

Task:
procedure expose eucl.
arg x
say 'The first' x 'Euclid-Mullin numbers are:'
eucl. = 0; eucl.euclid.1 = 2; eucl.0 = 1
p = 2
do i = 2 to x
   z = p+1; t = Ffactor(z); eucl.euclid.i = t; p = p*t
end
eucl.0 = x
do i = 1 to x
   call charout ,eucl.euclid.i' '
end
say
return x

Ffactor:
/* First prime factor */
procedure
arg x
/* Fast values */
if x < 4 then
   return x
/* Check low factors */
n = 0
pr = '2 3 5 7 11 13 17 19 23'
do i = 1 to Words(pr)
   p = Word(pr,i)
   if x//p = 0 then
      return p
end
/* Check higher factors */
do j = 29 by 6 while j*j <= x
   p = Right(j,1)
   if p <> 5 then
      if x//j = 0 then
         return j
   if p = 3 then
      iterate
   y = j+2
   if x//y = 0 then
      return y
end
/* Last factor */
if x > 1 then
   return x
return 0

include Functions
include Abend
