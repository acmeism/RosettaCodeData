-- 30 Jul 2025
include Settings
numeric digits 16
arg xx
if xx = '' then
   xx=60
ss=(xx>0); xx=Abs(xx)

say 'BERNOULLI NUMBERS'
say version
say

call Time('r')
call Rational1 xx
if ss then
   call ShowFractions xx
call Timer

call Time('r')
call Rational2 xx
if ss then
   call ShowFractions xx
call Timer

call Time('r')
call Decimal1 xx
if ss then
   call ShowDecimals xx
call Timer

call Time('r')
call Decimal2 xx
if ss then
   call ShowDecimals xx
call Timer
exit

Rational1:
procedure expose Memo. Bern.
arg xx
say 'Rational arithmetic'
say 'cf Generating function'
numeric digits Max(Digits(),3*xx)
Bern.=0; Bern.0='1 1'; Bern.1='-1 2'
do n = 2 by 2 to xx
   s=0
   do k = 0 to n-1
      s=Addq(s,Scaleq(Bern.k,Comb(n+1,k)))
   end k
   Bern.n=Mulq(Negq(s),Invq(n+1))
end n
return

Rational2:
procedure expose Memo. Bern.
arg xx
say 'Numerator and denominator calculations'
say 'cf Double sum formula optimized'
numeric digits Max(Digits(),3*xx)
Bern.=0; Bern.0='1 1'; Bern.1='-1 2'
do j = 2 by 2 to xx
   jp=j+1; sn=1-j; sd=2
   do k = 2 by 2 to j-1
      bn=bn.k; ad=ad.k; an=Comb(jp,k)*bn; tl=Lcm(sd,ad)
      sn=tl%sd*sn; sd=tl; an=tl%ad*an; sn=sn+an
   end k
   sn=-sn; sd=sd*jp; bn.j=sn; ad.j=sd; g=Gcd(Abs(sn),sd)
   Bern.j=sn/g sd/g
end j
return

ShowFractions:
procedure expose Bern.
arg xx
w=Length(Word(Bern.xx,1))+2
say ' Bn' Right('Num',w) '/' Left('Den',10) 'Decimal'
do i = 0 to xx
   if Bern.i <> 0 then do
      parse var Bern.i num den
      say Right(i,3) Right(num,w) '/' Left(den,10) Digit(num/den,16)
   end
end i
return

Decimal1:
procedure expose Bern. Memo.
arg xx
say 'Floating point calculations'
say 'cf Generating function'
numeric digits Max(Digits(),2*xx)
Bern.=0; Bern.0=1; Bern.1='-0.5'
do n = 2 by 2 to xx
   s=0
   do k = 0 to n-1
      s=s+Bern.k*Comb(n+1,k)
   end k
   Bern.n=-s/(n+1)
end n
return xx

Decimal2:
procedure expose Bern. Memo.
arg xx
say 'Floating point calculations'
say 'cf Akiyama-Tanigawa'
numeric digits Max(Digits(),3*xx)
Bern.=0; Bern.0=1; Bern.1=-0.5
do i = 2 by 2 to xx
   do m = 0 to i
      a.m=1/(m+1)
      do j = m by -1 to 1
         j1=j-1; a.j1=j*(a.j1-a.j)
      end
   end m
   Bern.i=a.0
end i
return xx

ShowDecimals:
procedure expose Bern.
arg xx
say ' Bn' 'Decimal'
do i = 0 to xx
   if Bern.i <> 0 then
      say Right(i,3) Digit(Bern.i,16)
end i
return

include Math
