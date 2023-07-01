/* REXX ***************************************************************
* Create a BMP file showing a few super ellipses
**********************************************************************/
Parse Version v
If pos('Regina',v)>0 Then
  superegg='superegga.bmp'
Else
  superegg='supereggo.bmp'
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
Call supegg black,080,080,0.5,u,v
Call supegg black,110,110,1 ,u,v
Call supegg black,140,140,1.5,u,v
Call supegg blue ,170,170,2 ,u,v
Call supegg red ,200,200,2.5,u,v
Call supegg green,230,230,3 ,u,v
Call supegg black,260,260,4 ,u,v
Call supegg black,290,290,7 ,u,v
Do i=1 To z.0
  s=s||z.i
  End

Call lineout superegg,s
Call lineout superegg
Exit

supegg:
Parse Arg color,a,b,n,u,v
Do y=0 To b
  t=(1-power(y/b,n))
  x=a*power(t,1/n)
  Call point color,format(u+x,4,0),format(v+y,4,0)
  Call point color,format(u-x,4,0),format(v+y,4,0)
  Call point color,format(u+x,4,0),format(v-y,4,0)
  Call point color,format(u-x,4,0),format(v-y,4,0)
  End
Do x=0 To a
  t=(1-power(x/b,n))
  y=a*power(t,1/n)
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

power: Procedure
/***********************************************************************
* Return b**x for any x -- with reasonable or specified precision
* 920903 Walter Pachl
***********************************************************************/
  Parse Arg b,x,prec
  If prec<9 Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  If b=0 Then Return 0
  If b<>'' Then x=x*ln(b,prec+2)
  o=1
  u=1
  r=1
  Do i=1 By 1
    ra=r
    o=o*x
    u=u*i
    r=r+(o/u)
    If r=ra Then Leave
    End
  Numeric Digits (prec)
  Return r+0

ln: Procedure
/***********************************************************************
* Return ln(x) -- with specified precision
* Three different series are used for the ranges  0 to 0.5
*                                                 0.5 to 1.5
*                                                 1.5 to infinity
* 920903 Walter Pachl
***********************************************************************/
  Parse Arg x,prec,b
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  Select
    When x<=0 Then r='*** invalid argument ***'
    When x<0.5 Then Do
      z=(x-1)/(x+1)
      o=z
      r=z
      k=1
      Do i=3 By 2
        ra=r
        k=k+1
        o=o*z*z
        r=r+o/i
        If r=ra Then Leave
        End
      r=2*r
      End
    When x<1.5 Then Do
      z=(x-1)
      o=z
      r=z
      k=1
      Do i=2 By 1
        ra=r
        k=k+1
        o=-o*z
        r=r+o/i
        If r=ra Then Leave
        End
      End
    Otherwise /* 1.5<=x */ Do
      z=(x+1)/(x-1)
      o=1/z
      r=o
      k=1
      Do i=3 By 2
        ra=r
        k=k+1
        o=o/(z*z)
        r=r+o/i
        If r=ra Then Leave
        End
      r=2*r
      End
    End
  If b<>'' Then
    r=r/ln(b)
  Numeric Digits (prec)
  Return r+0
