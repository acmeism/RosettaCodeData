/* REXX */
Numeric Digits 16
ps = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0)
Say "Position :" ps~x~tostring
Say "Speed    :" ps~y~tostring
Say 'Raku:'
pi=rxCalcpi(16)
ps=orbitalStateVectors(1,.1,pi/18,pi/6,pi/4,0) /*Raku*/
Say "Position :" ps~x~tostring
Say "Speed    :" ps~y~tostring

::class v2
::method init
  expose x y
  Use Arg x,y
::attribute x
::attribute y

::class vector
::method init
  expose x y z
  use strict arg x = 0, y = 0, z = 0  -- defaults to 0 for any non-specified coordinates

::attribute x
::attribute y
::attribute z

::method print
  expose x y z
  Numeric Digits 16
  Say 'Vector:'||x'/'y'/'z

::method tostring
  expose x y z
  Return '('||x','y','z')'

::method abs
  expose x y z
  Numeric Digits 16
  Return rxCalcsqrt(x**2+y**2+z**2,16)

::method '*'
  expose x y z
  Parse Arg f
  Numeric Digits 16
  Return .vector~new(x*f,y*f,z*f)

::method '/'
  expose x y z
  Parse Arg f
  Numeric Digits 16
  Return .vector~new(x/f,y/f,z/f)

::method '+'
  expose x y z
  Use Arg v2
  Numeric Digits 16
  Return .vector~new(x+v2~x,y+v2~y,z+v2~z)

::routine orbitalStateVectors
Use Arg  semimajorAxis,,
         eccentricity,,
         inclination,,
         longitudeOfAscendingNode,,
         argumentOfPeriapsis,,
         trueAnomaly
Numeric Digits 16
i = .vector~new(1, 0, 0)
j = .vector~new(0, 1, 0)
k = .vector~new(0, 0, 1)
p = rotate(i, j, longitudeOfAscendingNode)
i = p~x
j = p~y
p = rotate(j, k, inclination)
j = p~x
p = rotate(i, j, argumentOfPeriapsis)
i = p~x
j = p~y
If eccentricity=1 Then l=2
Else l=1-eccentricity*eccentricity
l*=semimajorAxis
c=rxCalccos(trueAnomaly,16,'R')
s=rxCalcsin(trueAnomaly,16,'R')
r=l/(1+eccentricity*c)
rprime=s*r*r/l
position=mulAdd(i,c,j,s)~'*'(r)
speed=mulAdd(i,rprime*c-r*s,j,rprime*s+r*c)
speed=speed~'/'(speed~abs)
speed=speed~'*'(rxCalcsqrt(2.0/r-1.0/semimajorAxis,16))
Return .v2~new(position,speed)

::routine muladd
  Use Arg v1,x1,v2,x2
  Numeric Digits 16
  w1=v1~'*'(x1)
  w2=v2~'*'(x2)
  Return w1~'+'(w2)

::routine rotate
  Use Arg i,j,alpha
  Numeric Digits 16
  xx=mulAdd(i,rxCalccos(alpha,16,'R'),j,rxCalcsin(alpha,16,'R'))
  yy=mulAdd(i,-rxCalcsin(alpha,16,'R'),j,rxCalccos(alpha,16,'R'))
  res=.v2~new(xx,yy)
  Return res

::requires 'rxmath' LIBRARY
