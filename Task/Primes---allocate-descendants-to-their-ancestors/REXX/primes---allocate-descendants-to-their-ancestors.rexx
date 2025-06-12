-- 25 Apr 2025
include Settings
numeric digits 20

call Time('r')
say 'PRIMES - ALLOCATE DESCENDANTS TO THEIR ANCESTORS'
say version
say
call Primes 100
call InitTotals
do n = 1 to 99
   call InitVarious
   call Ancestors n
   call Terms n,1,0,''
   call Descendants
   call Sort 'desc.'
   if n < 21 | Pos(n,46 62 74 94 99) > 0 then
      call ShowResults n
   call SumTotals
end
call ShowTotals
say Format(Time('e'),,3) 'seconds'; say
exit

InitTotals:
procedure expose tota.
tota. = 0
return

InitVarious:
procedure expose ance. term. desc.
ance. = 0; term. = 0; desc. = 0
return

Ancestors:
procedure expose ance.
arg xx
if xx < 5
   then return
f = Factors(xx)
if f = 1 then
   return
s = 0
do i = 1 to fact.0
   s = s+fact.i
end
ance.0 = ance.0+1; a = ance.0; ance.a = s
call Ancestors s
return

Terms:
procedure expose term. prim.
arg xx,ix,cs,cl
if xx < 5 then
   return
if cs = xx then do
   if Words(cl) > 1 then do
      term.0 = term.0+1; i = term.0; term.i = cl
   end
   return
end
do i = ix to prim.0
   p = prim.i; a = cs+p
   if a <= xx then
      call Terms xx,i,a,cl p
end
return

Descendants:
procedure expose desc. term.
do i = 1 to term.0
   a = term.i; p = 1
   do j = 1 to Words(a)
      p = p*Word(a,j)
   end
   desc.0 = desc.0+1; i = desc.0; desc.i = p
end
return

ShowResults:
procedure expose ance. desc.
arg xx
say '['xx']'
call Charout ,ance.0 'ancestors: '
do i = ance.0 by -1 to 1
   call Charout ,ance.i' '
end
say
call Charout ,desc.0 'descendants: '
if desc.0 < 7 then do
   do i = 1 to desc.0
      call Charout ,desc.i' '
   end
end
else do
   do i = 1 to 3
      call Charout ,desc.i' '
   end
   call Charout, '... '
   do i = desc.0-2 to desc.0
      call Charout ,desc.i' '
   end
end
say; say
return

SumTotals:
procedure expose ance. desc. tota.
tota.ance = tota.ance+ance.0
tota.desc = tota.desc+desc.0
return

ShowTotals:
procedure expose tota.
say '[Totals]'
say tota.ance 'ancestors'
say tota.desc 'descendants'
say
return

include Numbers
include Sequences
include Constants
include Functions
include Helper
include Abend
