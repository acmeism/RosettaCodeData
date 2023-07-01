/* REXX ***************************************************************
* Create a BMP file showing a few super ellipses
**********************************************************************/
Parse Version v
If pos('Regina',v)>0 Then
  superegg='superegga.bmp'
Else
  superegg='supereggx.bmp'
'erase' superegg
s='424d4600000000000000360000002800000038000000280000000100180000000000'X||,
  '1000000000000000000000000000000000000000'x
z.0=0
black='000000'x
white='ffffff'x
red  ='00ff00'x
green='ff0000'x
blue ='0000ff'x
m=80
n=80
hor=m*8      /* 56 */
ver=n*8      /* 40 */
s=overlay(lend(hor),s,19,4)
s=overlay(lend(ver),s,23,4)
z.=copies('f747ff'x,3192%3)
z.=copies('ffffff'x,8*m)
z.0=648
u=320
v=320
Call supegg black,120,120,1.5,u,v
Call supegg blue,160,160,2,u,v
Call supegg red,200,200,2.5,u,v
Call supegg green,240,240,3,u,v
Call supegg black,280,280,4,u,v

Do i=1 To z.0
  s=s||z.i
  End

Call lineout superegg,s
Call lineout superegg
Exit

supegg:
Parse Arg color,a,b,n,u,v
Do y=0 To b
  t=(1-rxCalcpower(y/b,n))
  x=a*rxCalcpower(t,1/n)
  Call point color,format(u+x,4,0),format(v+y,4,0)
  Call point color,format(u-x,4,0),format(v+y,4,0)
  Call point color,format(u+x,4,0),format(v-y,4,0)
  Call point color,format(u-x,4,0),format(v-y,4,0)
  End
Do x=0 To a
  t=(1-rxCalcpower(x/b,n))
  y=a*rxCalcpower(t,1/n)
  Call point color,format(u+x,4,0),format(v+y,4,0)
  Call point color,format(u-x,4,0),format(v+y,4,0)
  Call point color,format(u+x,4,0),format(v-y,4,0)
  Call point color,format(u-x,4,0),format(v-y,4,0)
  End
Return

lend:
Return reverse(d2c(arg(1),4))

point: Procedure Expose z.
  Call trace 'O'
  Parse Arg color,x0,y0
  --Say x0 y0
  Do x=x0-2 To x0+2
    Do y=y0-2 To y0+2
      z.y=overlay(copies(color,3),z.y,3*x)
      End
    End
  Return

::requires rxMath library
