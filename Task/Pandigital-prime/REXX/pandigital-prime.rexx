-- 24 Aug 2025
include Setting

say 'PANDIGITAL PRIME'
say version
say
call ShowPandigital 4
call ShowPandigital 5,0
call ShowPandigital 7
call ShowPandigital 8,0
exit

ShowPandigital:
procedure
arg xx,yy
call Time('r')
say 'Largest pandigital'yy 'prime with' xx 'digits...'
p = Right('987654321'yy,xx); c = p-(yy=0)
do c = c by -2
   if Verify(p,c) > 0 then
      iterate
   if Prime(c) then
      leave
end
say 'is' c
say Format(Time('e'),,3) 'seconds'; say
return

include Math
