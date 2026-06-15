-- 13 Jun 2026
include Setting
numeric digits 10

say 'LUCAS-CARMICHAEL NUMBERS'
say version
say
call GetNumbers 2,1e5
call ShowNumbers 2,1e5
call Timer
exit

GetNumbers:
procedure expose Luca. Ufac. Glob.
arg xx,yy
say 'Get LuCa numbers...'
xx=xx+Even(xx)
Luca.=0; n=0
do i=xx by 2 to yy
   if Prime(i) then
      iterate i
   if \ Squarefree(i) then
      iterate i
   i1=i+1
   a=Ufactors(i)
   do j=1 to a
      u1=Ufac.j+1
      if i1//u1>0 then
         iterate i
   end
   n+=1; Luca.n=i
end
Luca.0=n
say n 'numbers found'
say
return

ShowNumbers:
procedure expose Luca.
arg xx,yy
say 'Lucas-Carmichael numbers between' xx 'and' yy'...'
do i=1 to Luca.0
   call Charout ,Right(Luca.i,7)
   if i//10=0 then
      say
end
say; say
return

-- Even; Prime; Squarefree; Ufactors; Timer
include Math
