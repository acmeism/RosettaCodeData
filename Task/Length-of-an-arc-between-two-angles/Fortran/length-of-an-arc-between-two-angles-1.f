*-----------------------------------------------------------------------
* given:  polar coordinates of two points on a circle of known radius
* find:  length of the major arc between these points
*
*___Name_____Type___I/O___Description___________________________________
*   RAD      Real   In    Radius of circle, any unit of measure
*   ANG1     Real   In    Angle of first point, degrees
*   ANG2     Real   In    Angle of second point, degrees
*   MAJARC   Real   Out   Length of major arc, same units as RAD
*-----------------------------------------------------------------------
      FUNCTION MAJARC (RAD, ANG1, ANG2)
       IMPLICIT NONE
       REAL RAD, ANG1, ANG2, MAJARC

       REAL FACT                          ! degrees to radians
       PARAMETER (FACT = 3.1415926536 / 180.)
       REAL DIF

*       Begin
       MAJARC = 0.
       IF (RAD .LE. 0.) RETURN
       DIF = MOD(ABS(ANG1 - ANG2), 360.)   ! cyclic difference
       DIF = MAX(DIF, 360. - DIF)          ! choose the longer path
       MAJARC = RAD * DIF * FACT           ! L = r theta
       RETURN
      END  ! of majarc

*-----------------------------------------------------------------------
      PROGRAM TMA
       IMPLICIT NONE
       INTEGER J
       REAL ANG1, ANG2, RAD, MAJARC, ALENG
       REAL DATARR(3,3)
       DATA DATARR / 120.,  10., 10.,
     $                10., 120., 10.,
     $               180., 270., 10. /

       DO J = 1, 3
         ANG1 = DATARR(1,J)
         ANG2 = DATARR(2,J)
         RAD = DATARR(3,J)
         ALENG = MAJARC (RAD, ANG1, ANG2)
         PRINT *, 'first angle: ', ANG1, ' second angle: ', ANG2,
     $     ' radius: ', RAD, ' Length of major arc: ', ALENG
       END DO
      END

