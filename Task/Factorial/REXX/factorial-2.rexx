-- 8 May 2025
include Settings

say 'FACTORIAL'
say version
say
call First20
call Imp 10,'1 10 100 1000 10000 100000 1000000 10000000 100000000 130202808'
call Rec 10,'1 10 100 1000 10000 100000 200000'
call Imp 100,'69'
call Imp 1000,'449'
call Imp 10000,'3248'
call Imp 100000,'25205'
exit

First20:
say 'First 20 factorials...'
numeric digits 30
do n = 1 to 20
   say n'! =' Fact(n)
end
say
return

Imp:
glob. = ''
call Time('r')
arg d,p
numeric digits d; fact. = 0
say 'Imperative in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Fact(f)
   parse var h 'E' e
   if e = '' then
      say right(f'!',10) 'has exact' right(Length(h),9) 'digits' '('Format(Time('e'),,3)'s)'
   else
      say right(f'!',10) 'has about' right(e+1,9) 'digits' '('Format(Time('e'),,3)'s)'
end
say
return

Rec:
glob. = ''
call Time('r')
arg d,p
numeric digits d; fact. = 0
say 'Recursive in' d 'digits precision...'
do i = 1 to Words(p)
   call Time('r'); f = Word(p,i); h = Recursive(f)
   parse var h 'E' e
   if e = '' then
      say right(f'!',10) 'has exact' right(Length(h),9)  'digits' '('Format(Time('e'),,3)'s)'
   else
      say right(f'!',10) 'has about' right(e+1,9) 'digits' '('Format(Time('e'),,3)'s)'
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

include Functions
include Special
include Abend
