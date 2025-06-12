-- 8 May 2025
include Settings
numeric digits 30

call Time('r')
say 'PROPER DIVISORS'
say version
say
call Task2 10
call Task3 20000
call Task3 1e6
call Task4
say Format(Time('e'),,3) 'seconds'
exit

Task2:
procedure expose divi.
arg xx
say 'Proper divisors for numbers below' xx'...'
do i = 1 to 10
   n = Divisors(i)-1
   call Charout, 'The' n 'proper divisors of' i 'are '
   do j = 1 to n
      call Charout ,divi.j' '
   end
   say
end
say
return

Task3:
procedure expose divi.
arg xx
say 'The first number with the most proper divisors below' xx'...'
m = 0
do i = 1 to xx
   n = Divisor(i)-1
   if n > m then do
      m = n; j = i
   end
end
n = Divisors(j)-1
say j 'has' n 'proper divisors'
say
return

Task4:
procedure expose divi.
arg xx
say 'Some numbers with a lot of proper divisors...'
a = '1441440 21621600 6983776800 321253732800 65214507758400 6064949221531200 224403121196654400'
do w = 1 to Words(a)
   n = Word(a,w)
   say n 'has' Divisor(n)-1 'proper divisors'
end
say
return

include Sequences
include Functions
include Special
include Abend
