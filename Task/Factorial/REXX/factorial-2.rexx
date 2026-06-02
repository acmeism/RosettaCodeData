-- 15 May 2026
include Setting
Memo.cache=0

say 'Factorial'
say version
say
call First20
call Timer 'r'
call Imperative 10, '1 13 71 450 3249 25206 205022 1723508 14842907 130202808'
call Timer 'r'
if pos('Regina',version) > 0 then
   call Recursive 10, '1 13 71 450 3249 25206 205022'
else
   call Recursive 10, '1 13 71 450 3249'
call Timer 'r'
call Imperative 100000,'1 13 71 450 3249 25206'
call Timer 'r'
exit

First20:
say 'First 20 FactorialS...'
numeric digits 30
do n = 1 to 20
   say n'! =' Fact(n)
end
say
return

Imperative:
arg d,p
numeric digits d
say 'Imperative in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Fact(f)
   parse var h 'E' e
   if e = '' then
      say Right(f'!',10) 'has exact' Right(Length(h),9) 'digits'
   else
      say Right(f'!',10) 'has about' Right(e+1,9) 'digits'
end
say
return

Recursive:
arg d,p
numeric digits d
say 'Recursive in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Recurs(f)
   parse var h 'E' e
   if e = '' then
      say Right(f'!',10) 'has exact' Right(Length(h),9) 'digits'
   else
      say Right(f'!',10) 'has about' Right(e+1,9) 'digits'
end
say
return

Recurs:
procedure
arg xx
if xx = 0 then
   return 1
else
   return xx*Recurs(xx-1)

-- Timer Fact
include Math
