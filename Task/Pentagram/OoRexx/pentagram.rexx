/* REXX ***************************************************************
* Create a BMP file showing a pentagram
**********************************************************************/
pentagram='pentagram.bmp'
'erase' pentagram
s='424d4600000000000000360000002800000038000000280000000100180000000000'X
s=s'1000000000000000000000000000000000000000'x
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
s72 =RxCalcsin(72,,'D')
c72 =RxCalccos(72,,'D')
s144=RxCalcsin(144,,'D')
c144=RxCalccos(144,,'D')
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
::requires RxMath Library
