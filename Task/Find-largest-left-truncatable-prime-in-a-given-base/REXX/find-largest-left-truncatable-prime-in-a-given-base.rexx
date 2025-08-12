-- 28 Jul 2025
include Settings
numeric digits 100

say 'LEFT TRUNCATABLE PRIME IN GIVEN BASE'
say version
say
work. = 0
bases = '3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 19 21 23 25'
do i = 1 to Words(bases)
   base = Word(bases,i)
   call First base
   do work.digit = 1 while work.out.0 > 0
      call Show base
      call Copy base
      call Next base
   end
   call Result base
end
say Words(bases) 'bases specified'
say work.cycle 'digit cycles needed'
say work.count 'numbers tested for primality'
say work.Prime 'of them were actually prime'
say Format(Time('e'),,3) 'seconds'
exit

First:
procedure expose work.
arg x
say 'Base' x'...'
a = '2 3 5 7 11 13 17 19 23 25 27 29 31 33 35'
n = 0; b = 2
do i = 2 while b <= x
   n = n+1; work.out.n = b; b = Word(a,i)
end
work.out.0 = n
return

Show:
procedure expose work.
arg x
work.cycle = work.cycle+1
if x < 0 then do
   do i = 1 to work.out.0
      say i work.out.i 'is prime'
   end
end
say Right(work.out.0,5) 'candidates with' Right(work.digit,2) 'digits ('Format(Time('e'),,3)'s)'
return

Copy:
procedure expose work.
arg x
do i = 1 to work.out.0
   work.in.i = work.out.i
end
work.in.0 = work.out.0
return

Next:
procedure expose work. Memo.
arg x
n = 0
do i = 1 to work.in.0
   a = work.in.i; b = x**work.digit
   do j = 1 to x-1
      work.count = work.count+1; c = a+b*j
      if Prime(c) then do
         work.Prime = work.Prime+1; n = n+1; work.out.n = c
      end
   end
end
work.out.0 = n
return

Result:
procedure expose work.
arg x
m = 0
do i = 1 to work.in.0
   m = Max(m,work.in.i)
end
say 'Largest left truncatable prime for base' x 'is' m '('BaseNN(m,x)')'
say
return

include Math
