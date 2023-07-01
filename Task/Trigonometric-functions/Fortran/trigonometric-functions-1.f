PROGRAM Trig

  REAL pi, dtor, rtod, radians, degrees

  pi = 4.0 * ATAN(1.0)
  dtor = pi / 180.0
  rtod = 180.0 / pi
  radians = pi / 4.0
  degrees = 45.0

  WRITE(*,*) SIN(radians), SIN(degrees*dtor)
  WRITE(*,*) COS(radians), COS(degrees*dtor)
  WRITE(*,*) TAN(radians), TAN(degrees*dtor)
  WRITE(*,*) ASIN(SIN(radians)), ASIN(SIN(degrees*dtor))*rtod
  WRITE(*,*) ACOS(COS(radians)), ACOS(COS(degrees*dtor))*rtod
  WRITE(*,*) ATAN(TAN(radians)), ATAN(TAN(degrees*dtor))*rtod

END PROGRAM Trig
