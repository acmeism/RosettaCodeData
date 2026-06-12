-- 8 Nov 2025
-- https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
include Setting
numeric Digits 20

say 'RODRIGUES'' ROTATION FORMULA'
say version
say
pi=Pi()
axis   ='-1.0 2.0 1.0'
vectorp='2.5 -1.5 3.0'
kp=UnitV(axis)
Say "Angle      Rotated vector"
Say "------------------------------------------------"
Do thetad=0 to 360  by 36
  theta=pi*thetad/180
  t1=ScaleV(vectorp,Cos(theta))
  t2=ScaleV(CrossV(kp,vectorp),Sin(theta))
  t3=ScaleV(kp,(1-Cos(theta))*DotV(kp,vectorp))
  t=AddV(t1,t2,t3)
  del.=','
  del.3=']'
  ol=Format(theta,1,8) '['
  Do i=1 To 3
    ol=ol||Format(Word(t,i),2,8)del.i
    End
  say ol
  End
Exit

-- Sin; Cos; Pi
include Trigonometric
-- ScaleV; CrossV; DotV, AddV
include Vector
