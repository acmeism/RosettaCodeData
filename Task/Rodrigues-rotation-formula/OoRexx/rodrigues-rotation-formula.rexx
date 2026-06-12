/* REXX */
-- https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
pi=2*rxCalcarcsin(1,,'R')
axis   =.Vector~new(-1.0, 2.0, 1.0)
vector =.Vector~new(2.5, -1.5, 3.0)
k=axis~unitvector
Say "Angle      Rotated vector"
Say "------------------------------------------------"
Do thetad=0 to 360  by 36
  theta=pi*thetad/180
  t1= vector~scalarmultiply(rxCalccos(thetad))
  t2=(k~crossproduct(vector))~scalarmultiply(rxCalcsin(thetad))
  t3=k~scalarmultiply(((1-rxCalccos(thetad))*k~dotproduct(vector)))
  t=(t1~add(t2))~add(t3)
  say format(theta,1,8) t
  End
Exit

::CLASS vector public inherit stringlike
::Attribute X
::Attribute Y
::Attribute Z

::Method init   public
  Expose X Y Z
  Use Arg x,y,z

::Method dotproduct public
  Expose X Y Z
  Use Arg other
  Return x*other~x+y*other~y+z*other~z

::Method unitVector public
  Return self~scalarMultiply(1.0 / rxCalcsqrt(self~dotProduct(self)))

::Method add public
  Expose X Y Z
  Use Arg other
  return .Vector~new(x+other~x,y+other~y,z+other~z)

::Method scalarMultiply public
  Expose X Y Z
  Arg value
  return .Vector~new(x*value,y*value,z*value)

::Method crossProduct public
  Expose X Y Z
  Use Arg other
  return .Vector~new(y*other~z-z*other~y,,
                     z*other~x-x*other~z,,
                     x*other~y-y*other~x)

::Method string public
  Expose X Y Z
  Return '['format(x,2,8)','format(y,2,8)','format(z,2,8)']'

::Class "Stringlike" public MIXINClass object

::REQUIRES rxMath Library
