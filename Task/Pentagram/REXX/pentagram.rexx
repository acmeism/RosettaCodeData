/* REXX ***************************************************************
* Create a BMP file showing a pentagram
**********************************************************************/
Parse Version v
If pos('Regina',v)>0 Then
  pentagram='pentagrama.bmp'
Else
  pentagram='pentagramx.bmp'
'erase' pentagram
s='424d4600000000000000360000002800000038000000280000000100180000000000'X||,
  '1000000000000000000000000000000000000000'x
Say 'sl='length(s)
z.0=0
white='ffffff'x
red  ='00ff00'x
green='ff0000'x
blue ='0000ff'x
rd6=copies(rd,6)
m=133
m=80
n=80
hor=m*8      /* 56 */
ver=n*8      /* 40 */
Say 'hor='hor
Say 'ver='ver
Say 'sl='length(s)
s=overlay(lend(hor),s,19,4)
s=overlay(lend(ver),s,23,4)
Say 'sl='length(s)
z.=copies('ffffff'x,3192%3)
z.=copies('ffffff'x,8*m)
z.0=648
pi_5=2*3.14159/5
s72 =sin(pi_5  )
c72 =cos(pi_5  )
s144=sin(pi_5*2)
c144=cos(pi_5*2)
xm=300
ym=300
r=200
p.0x.1=xm
p.0y.1=ym+r

p.0x.2=format(xm+r*s72,3,0)
p.0y.2=format(ym+r*c72,3,0)
p.0x.3=format(xm+r*s144,3,0)
p.0y.3=format(ym+r*c144,3,0)
p.0x.4=format(xm-r*s144,3,0)
p.0y.4=p.0y.3
p.0x.5=format(xm-r*s72,3,0)
p.0y.5=p.0y.2
Do i=1 To 5
  Say p.0x.i p.0y.i
  End
Call line p.0x.1,p.0y.1,p.0x.3,p.0y.3
Call line p.0x.1,p.0y.1,p.0x.4,p.0y.4
Call line p.0x.2,p.0y.2,p.0x.4,p.0y.4
Call line p.0x.2,p.0y.2,p.0x.5,p.0y.5
Call line p.0x.3,p.0y.3,p.0x.5,p.0y.5

Do i=1 To z.0
  s=s||z.i
  End

Call lineout pentagram,s
Call lineout pentagram
Exit

lend:
Return reverse(d2c(arg(1),4))

line: Procedure Expose z. red green blue
Parse Arg x0, y0, x1, y1
Say 'line'  x0  y0  x1  y1
dx = abs(x1-x0)
dy = abs(y1-y0)
if x0 < x1 then sx = 1
           else sx = -1
if y0 < y1 then sy = 1
           else sy = -1
err = dx-dy

Do Forever
  xxx=x0*3+2
  Do yy=y0-1 To y0+1
    z.yy=overlay(copies(blue,5),z.yy,xxx)
    End
  if x0 = x1 & y0 = y1 Then Leave
  e2 = 2*err
  if e2 > -dy then do
    err = err - dy
    x0 = x0 + sx
    end
  if e2 < dx then do
    err = err + dx
    y0 = y0 + sy
    end
  end
Return

sin: Procedure
/* REXX ****************************************************************
* Return sin(x<,p>) -- with the specified precision
***********************************************************************/
  Parse Arg x,prec
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  pi=3.14159
  Do While x>pi
    x=x-pi
    End
  Do While x<-pi
    x=x+pi
    End
  o=x
  u=1
  r=x
  Do i=3 By 2
    ra=r
    o=-o*x*x
    u=u*i*(i-1)
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits prec
  Return r+0

cos: Procedure
/* REXX ****************************************************************
* Return cos(x) -- with specified precision
***********************************************************************/
  Parse Arg x,prec
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz 3
  o=1
  u=1
  r=1
  Do i=1 By 2
    ra=r
    o=-o*x*x
    u=u*i*(i+1)
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits prec
  Return r+0

sqrt: Procedure
/* REXX ***************************************************************
* EXEC to calculate the square root of a = 2 with high precision
**********************************************************************/
  Parse Arg x,prec
  If prec<9 Then prec=9
  prec1=2*prec
  eps=10**(-prec1)
  k = 1
  Numeric Digits 3
  r0= x
  r = 1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<eps)
    r0 = r
    r  = (r + x/r) / 2
    k  = min(prec1,2*k)
    Numeric Digits (k + 5)
    End
  Numeric Digits prec
  Return r+0
