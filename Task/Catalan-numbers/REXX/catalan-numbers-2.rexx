/* REXX ---------------------------------------------------------------
* 01.07.2014 Walter Pachl
*--------------------------------------------------------------------*/
Numeric Digits 1000
Parse Arg m .
If m='' Then m=20
Do i=0 To m
  c1.i=c1(i)
  End
c2.=1
Do i=1 To m
  c2.i=c2(i)
  End
c3.=1
Do i=1 To m
  im1=i-1
  c3.i=2*(2*i-1)*c3.im1/(i+1)
  End
l=length(c3.m)
hdr=' n' right('c1.n',l),
         right('c2.n',l),
         right('c3.n',l)
Say hdr
Do i=0 To m
  Say right(i,2) format(c1.i,l),
                 format(c2.i,l),
                 format(c3.i,l)
  End
Say hdr
Exit

c1: Procedure
Parse Arg n
return fact(2*n)/(fact(n)*fact(n+1))

c2: Procedure Expose c2.
Parse Arg n
res=0
Do i=0 To n-1
  nmi=n-i-1
  res=res+c2.i*c2.nmi
  End
Return res

fact: Procedure
Parse Arg n
f=1
Do i=1 To n
  f=f*i
  End
Return f
