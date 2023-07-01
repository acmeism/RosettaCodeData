Numeric Digits 100
Do r=0 To 20
  ra=r-1
  If r=0 Then
    f.r.1=1
  Else Do
    rsum=0
    Do c=2 To r+1
      ca=c-1
      f.r.c=fdivide(fmultiply(f.ra.ca,r),c)
      rsum=fsum(rsum,f.r.c)
      End
    f.r.1=fsubtract(1,rsum)
    End
  End
Do r=0 To 9
  ol=''
  Do c=1 To r+1
    ol=ol right(f.r.c,5)
    End
  Say ol
  End
Say ''
x=0
Do c=1 To 18
  x=fsum(x,fmultiply(f.17.c,(1000**c)))
  End
Say k(x)
s=0
Do k=1 To 1000
  s=s+k**17
  End
Say s
Exit

fmultiply: Procedure
Parse Arg a,b
Parse Var a ad '/' an
Parse Var b bd '/' bn
If an='' Then an=1
If bn='' Then bn=1
res=(abs(ad)*abs(bd))'/'||(an*bn)
Return s(ad,bd)k(res)

fdivide: Procedure
Parse Arg a,b
Parse Var a ad '/' an
Parse Var b bd '/' bn
If an='' Then an=1
If bn='' Then bn=1
res=s(ad,bd)(abs(ad)*bn)'/'||(an*abs(bd))
Return k(res)

fsum: Procedure
Parse Arg a,b
Parse Var a ad '/' an
Parse Var b bd '/' bn
If an='' Then an=1
If bn='' Then bn=1
n=an*bn
d=ad*bn+bd*an
res=d'/'n
Return k(res)

fsubtract: Procedure
Parse Arg a,b
Parse Var a ad '/' an
Parse Var b bd '/' bn
If an='' Then an=1
If bn='' Then bn=1
n=an*bn
d=ad*bn-bd*an
res=d'/'n
Return k(res)

s: Procedure
Parse Arg ad,bd
s=sign(ad)*sign(bd)
If s<0 Then Return '-'
       Else Return ''

k: Procedure
Parse Arg a
Parse Var a ad '/' an
Select
  When ad=0 Then Return 0
  When an=1 Then Return ad
  Otherwise Do
    g=gcd(ad,an)
    ad=ad/g
    an=an/g
    Return ad'/'an
    End
  End

gcd: procedure
Parse Arg a,b
if b = 0 then return abs(a)
return gcd(b,a//b)
