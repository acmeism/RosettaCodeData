include Settings

say version; say 'Factorial'; say
p = '10 20 52 104 208 416 1e3 1e4 1e5 1e6 1e7 1e8'
call Val 100
p = '10 20 52 104 208 416 1e3 1e4 1e5 1e6'
call Dig 100
call Dig 1000
call Dig 3000
p = '10 20 52 104 208 416 1e3 1e4 1e5'
call Dig 40000
call Dig 500000
p = '10 20 52 104 208 416 1e3 1e4'
call Dig 5000000
exit

Val:
call Time('r')
arg d
numeric digits d; fact. = 0
say 'Precision is' d 'digits'
do i = 1 to Words(p)
   call Time('r');f = Word(p,i); say f'!' '=' Fact(f) '('Format(Time('e'),,3)'s)'
end
say
return

Dig:
call Time('r')
arg d
numeric digits d; fact. = 0
say 'Precision is' d 'digits'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Fact(f)
   parse var h 'E' e
   if e = '' then
      say f'!' 'has exact' Length(h) 'digits' '('Format(Time('e'),,3)'s)'
   else
      say f'!' 'has about' e+1 'digits' '('Format(Time('e'),,3)'s)'
end
say
return

Fact:
/* Factorial = n! */
procedure expose fact.
arg x
/* Current in memory? */
if fact.factorial.x <> 0 then
   return fact.factorial.x
/* Previous in memory? */
w = x-1
if fact.factorial.w = 0 then do
/* Loop cf definition */
   y = 1
   do n = 2 to x
      y = y*n
   end
   fact.factorial.x = y
end
else
/* Multiply */
   fact.factorial.x = fact.factorial.w*x
return fact.factorial.x

include Functions
include Abend
