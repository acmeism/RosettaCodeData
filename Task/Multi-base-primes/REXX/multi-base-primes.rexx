-- 22 Mar 2025
include Settings

say 'MULTI-BASE PRIMES'
say version
say
arg ww
if ww = '' then
   ww = 4
call GetPrimes
call Collect
call Report
exit

GetPrimes:
call time('r')
a = 2*36*10**ww
say 'Get primes up to' a'...'
call Primes 2*36*10**ww
say Time('e')/1 'seconds'; say
return

Collect:
call time('r')
say 'Collect bases up to' ww'-character numbers...'
base. = ''
do j = 1 to prim.0
   do b = 36 by -1 to 2
      n = Basenn(prim.j,b); l = Length(n)
      if l > ww then
         iterate
      if l = 1 then
         base.l.n = b base.l.n
      else
         base.l.n = base.l.n b
   end
end
say Time('e')/1 'seconds'; say
return

Report:
call time('r')
say 'Report bases up to' ww'-character numbers...'
do w = 1 to ww
   a = Left(1,w,0); b = Left(9,w,9); c = 0
   do n = a to b
      y = Words(base.w.n)
      if y > c then do
         mxn = n;  c = Max(c,y)
      end
   end
   say w'-character numbers that are prime in the most bases ('c')'
   do n = a to b
      y = Words(base.w.n)
      if y = c then
         say n  'in' Strip(base.w.n)
   end
   say
end
say Time('e')/1 'seconds'; say
return

include Sequences
include Numbers
include Functions
include Abend
