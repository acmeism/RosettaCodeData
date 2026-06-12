-- 4 Mar 2026
include Setting

say 'POLYNOMIAL SYNTHETIC DIVISION'
say version
say
call Divide '1 -12 0 -42','1 -3'
call Divide '5 4 1','2 3'
call Divide '5 0 0 4 0 0 0 0 0 0 1','2 0 2 0 3'
call Divide '2 -24 2 -108 3 -120 0 -126','2 0 2 0 3'
call Divide '1 2','1 2 3'
call Divide '1 2 3','1 2 3'
call Divide '1 2 3','2'
call Divide '2 0 0','1 0'
exit

Divide:
arg x,y
z = Divides(x,y); parse var z q','r
say 'Formula:' Poly2form(x) '/' Poly2form(y) '=' Poly2form(q) 'Rem' Poly2form(r)
say 'Check  :' Poly2form(q) '*' Poly2form(y) '+' Poly2form(r) '=' Poly2form(AddP(MulP(q,y),r))
say
return

Divides:
-- Synthetic division
procedure expose work.
arg xx,yy
-- Fast values
wx = Words(xx); wy = Words(yy)
if wx < wy then
   return 0','xx
if wy = 1 then
   return MulP(1/yy,xx)','0
-- Coefs->arrays
work. = 0
do i = 1 to wx
   w = Word(xx,i); work.coefx.i = w; work.coefz.i = w
end
do i = 1 to wy
   w = Word(yy,i); work.coefy.i = w
end
-- Divide
wq = wy-1
do i = 1 to wx-wq
   if work.coefz.i <> 0 then do
      work.coefz.i = work.coefz.i/work.coefy.1
      do j = 1 to wq
         a = i+j; b = j+1
         work.coefz.a = work.coefz.a-work.coefy.b*work.coefz.i
      end
   end
end
-- Arrays->coefs
s = wx-wy+1
zq = ''
do i = 1 to s
   zq = zq work.coefz.i
end
zr = ''
do i = s+1 to wx
   zr = zr work.coefz.i
end
return Normal(zq)','Normal(zr)

-- MulP; Normal; Poly2form; AddP
include Math
