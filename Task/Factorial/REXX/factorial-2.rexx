-- 30 Jul 2025
include Settings

say 'Factorial'
say version
say
call First20
call Imp 10, '1 13 71 450 3249 25206 205022 1723508 14842907 130202808'
call ReC 10, '1 13 71 450 3249 25206 205022'
call Imp 1E6,'1 13 71 450 3249 25206'
exit

First20:
say 'First 20 FactorialS...'
numeric digits 30
do n = 1 to 20
   say n'! =' Fact(n)
end
say
return

Imp:
call ResetMemo
call Time('r')
arg d,p
numeric digits d; Fact. = 0
say 'Imperative in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Fact(f)
   parse var h 'E' e
   if e = '' then
      say Right(f'!',10) 'has exact' Right(Length(h),9) 'digits' '('Format(Time('e'),,3)'s)'
   else
      say Right(f'!',10) 'has about' Right(e+1,9) 'digits' '('Format(Time('e'),,3)'s)'
end
say
return

ReC:
call ResetMemo
call Time('r')
arg d,p
numeric digits d; Fact. = 0
say 'Recursive in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Recursive(f)
   parse var h 'E' e
   if e = '' then
      say Right(f'!',10) 'has exact' Right(Length(h),9)  'digits' '('Format(Time('e'),,3)'s)'
   else
      say Right(f'!',10) 'has about' Right(e+1,9) 'digits' '('Format(Time('e'),,3)'s)'
end
say
return

Recursive:
procedure
arg xx
if xx = 0 then
   return 1
else
   return xx*Recursive(xx-1)

include Math
