/* REXX */
Numeric Digits 16
  Parse Value orbitalStateVectors(1.0,0.1,0.0,355.0/(113.0*6.0),0.0,0.0),
      With position speed
  Say "Position :" tostring(position)
  Say "Speed    :" tostring(speed)
  Exit

orbitalStateVectors: Procedure
  Parse Arg semimajorAxis,,
            eccentricity,,
            inclination,,
            longitudeOfAscendingNode,,
            argumentOfPeriapsis,,
            trueAnomaly
  i='1/0/0'
  j='0/1/0'
  k='0/0/1'
  Parse Value rotate(i, j, longitudeOfAscendingNode) With i j
  Parse Value rotate(j, k, inclination) With j p
  Parse Value rotate(i, j, argumentOfPeriapsis) With i j
  If eccentricity=1 Then l=2
  Else l=1-eccentricity*eccentricity
  l=l*semimajorAxis
  c=my_cos(trueAnomaly,16)
  s=my_sin(trueAnomaly,16)
  r=l/(1+eccentricity*c)
  rprime=s*r*r/l
  position=vmultiply(mulAdd(i,c,j,s),r)
  speed=mulAdd(i,rprime*c-r*s,j,rprime*s+r*c)
  speed=vdivide(speed,abs(speed))
  speed=vmultiply(speed,my_sqrt(2.0/r-1.0/semimajorAxis,16))
  Return position speed

abs: Procedure
  Parse Arg v.x '/' v.y '/' v.z
  Return my_sqrt(v.x**2+v.y**2+v.z**2,16)

muladd: Procedure
  Parse Arg v1,x1,v2,x2
  Parse Var v1 v1.x '/' v1.y '/' v1.z
  Parse Var v2 v2.x '/' v2.y '/' v2.z
  z=(v1.x*x1+v2.x*x2)||'/'||(v1.y*x1+v2.y*x2)||'/'||(v1.z*x1+v2.z*x2)
  Return z

rotate: Procedure
Parse Arg i,j,alpha
  xx=mulAdd(i,my_cos(alpha,16,'R'),j,my_sin(alpha,16))
  yy=mulAdd(i,-my_sin(alpha,16,'R'),j,my_cos(alpha,16))
  Return xx yy

vmultiply: Procedure
  Parse Arg v,d
  Parse Var v v.x '/' v.y '/' v.z
  Return (v.x*d)||'/'||(v.y*d)||'/'||(v.z*d)

vdivide: Procedure
  Parse Arg v,d
  Parse Var v v.x '/' v.y '/' v.z
  Return (v.x/d)||'/'||(v.y/d)||'/'||(v.z/d)

tostring:
  Parse Arg v.x '/' v.y '/' v.z
  Return '('v.x','v.y','v.z')'

my_sqrt: Procedure
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
  Do i=1 By 1 Until r=r0 | ('ABS'(r*r-x)<eps)
    r0 = r
    r  = (r + x/r) / 2
    k  = min(prec1,2*k)
    Numeric Digits (k + 5)
    End
  Numeric Digits prec
  Return r+0

my_sin: Procedure
/* REXX ****************************************************************
* Return my_sin(x<,p>) -- with the specified precision
* my_sin(x) = x-(x**3/3!)+(x**5/5!)-(x**7/7!)+-...
***********************************************************************/
  Parse Arg x,prec
  If prec='' Then prec=9
  Numeric Digits (2*prec)
  Numeric Fuzz   3
  pi=left('3.1415926535897932384626433832795028841971693993751058209749445923',2*prec+1)
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

my_cos: Procedure
/* REXX ****************************************************************
* Return my_cos(x) -- with specified precision
* my_cos(x) = 1-(x**2/2!)+(x**4/4!)-(x**6/6!)+-...
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
