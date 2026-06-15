-- 12 Jun 2026
include Setting
numeric digits 100

say 'LARGEST LEFT TRUNCATABLE PRIME IN GIVEN BASE'
say version
say
Work. = 0
bases = '3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 19 21 23 25'
do i = 1 to Words(bases)
   base = Word(bases,i)
   call First base
   do Work.digit = 1 while Work.out.0 > 0
      call Show base
      call Copy base
      call Next base
   end
   call Result base
end i
say Words(bases) 'bases specified'
say Work.cycle 'digit cycles needed'
say Work.count 'numbers tested for primality'
say Work.Prime 'of them were actually prime'
say Format(Time('e'),,3) 'seconds'
exit

First:
procedure expose Work.
arg x
say 'Base' x'...'
a = '2 3 5 7 11 13 17 19 23 25 27 29 31 33 35'
n = 0; b = 2
do i = 2 while b <= x
   n = n+1; Work.out.n = b; b = Word(a,i)
end i
Work.out.0 = n
return

Show:
procedure expose Work.
arg x
Work.cycle = Work.cycle+1
if x < 0 then do
   do i = 1 to Work.out.0
      say i Work.out.i 'is prime'
   end i
end
say Right(Work.out.0,5) 'candidates with' Right(Work.digit,2) 'digits ('Format(Time('e'),,3)'s)'
return

Copy:
procedure expose Work.
arg x
do i = 1 to Work.out.0
   Work.in.i = Work.out.i
end i
Work.in.0 = Work.out.0
return

Next:
procedure expose Work. Glob.
arg x
n = 0
do i = 1 to Work.in.0
   a = Work.in.i; b = x**Work.digit
   do j = 1 to x-1
      Work.count = Work.count+1; c = a+b*j
      if Prime(c) then do
         Work.Prime = Work.Prime+1; n = n+1; Work.out.n = c
      end
   end j
end i
Work.out.0 = n
return

Result:
procedure expose Work.
arg x
m = 0
do i = 1 to Work.in.0
   m = Max(m,Work.in.i)
end i
say 'Largest left truncatable prime for base' x 'is' m '('D2n(m,x)')'
say
return

-- D2n Prime
include Math
