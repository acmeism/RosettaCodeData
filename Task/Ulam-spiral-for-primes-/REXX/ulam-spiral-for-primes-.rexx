-- 25 Apr 2025
include Settings
arg size','init

say 'ULAM SPIRAL'
say version
say
call Parameters
call Corners
call Spiral
call Pack
call Display
call Timer
exit

Parameters:
if size = '' then
   size = 79
tot = size**2
if init = '' then
   init =  1
return

Corners:
ur. = 0; br. = 0
do od = 1 by 2 to tot
   u = od**2+1; ur.u = 1; u = u+od; br.u = 1
end
bl. = 0; ul. = 0
do ev = 2 by 2 to tot
   u = ev**2+1; bl.u = 1; u = u+ev; ul.u = 1
end
return

Spiral:
app = 1; bigp = 0; hp = 0; inc = 0
minr = 1; maxr = 1; r = 1; d = 0; d. = ''; e. = ''
do i = init for tot
   r = r + inc; minr = Min(minr,r); maxr = Max(maxr,r)
   x = Prime(i)
   if x then
      bigp = Max(bigp,i)
   hp = hp + x
   if app then
      d.r = d.r||x
   else
      d.r = x||d.r
   if ur.i then do
      app = 1; inc = +1
      iterate i
   end
   if bl.i then do
      app = 0; inc = -1
      iterate i
   end
   if br.i then do
      app = 0; inc =  0
      iterate i
   end
   if ul.i then do
      app = 1; inc =  0
      iterate i
   end
end
return

Pack:
do j = minr by 2 to maxr
   jp = j+1; d = d+1
   do k = 1 for Length(d.j)
      top = Substr(d.j,k,1)
      bot = Word(Substr(d.jp,k,1)   0,1)
      if top then
         if bot then
            e.d = e.d||'DB'x
         else
            e.d = e.d||'DF'x
      else
         if bot then
            e.d = e.d||'DC'x
         else
            e.d = e.d' '
   end
end
return

Display:
do m = 1 for d
   say e.m
end
say
say init 'starting point,' tot 'numbers,' hp 'primes,' bigp 'largest prime'
return

include Functions
include Numbers
include Helper
include Abend
