PROGRAM CHAOS
 IMPLICIT NONE
 REAL, DIMENSION(3):: KA, KN ! Koordinates old/new
 REAL, DIMENSION(3):: DA, DB, DC ! Triangle
 INTEGER:: I, Z
 INTEGER, PARAMETER:: UT = 17
 ! Define corners of triangle
 DA = (/    0., 0.,   0. /)
 DB = (/  600., 0.,   0. /)
 DC = (/  500., 0., 400. /)
 ! Define starting point
 KA = (/  500., 0., 100. /)
 OPEN (UNIT = UT, FILE = 'aus.csv')
 DO I=1, 1000000
  Z = ZAHL()
  WRITE (UT, '(3(F12.6, ";"))') KA
  SELECT CASE (Z)
   CASE (1)
    CALL MITTELP(KA, DA, KN)
   CASE (2)
    CALL MITTELP(KA, DB, KN)
   CASE (3)
    CALL MITTELP(KA, DC, KN)
  END SELECT
  KA = KN
 END DO
 CLOSE (UT)
 CONTAINS
  ! Calculates center of two points
  SUBROUTINE MITTELP(P1, P2, MP)
   REAL, INTENT(IN), DIMENSION(3):: P1, P2
   REAL, INTENT(OUT), DIMENSION(3):: MP
   MP = (P1 + P2) / 2.
  END SUBROUTINE MITTELP
  ! Returns random number
  INTEGER FUNCTION ZAHL()
   REAL:: ZZ
   CALL RANDOM_NUMBER(ZZ)
   ZZ = ZZ * 3.
   ZAHL = FLOOR(ZZ) + 1
   IF (ZAHL .GT. 3) ZAHL = 3
  END FUNCTION ZAHL
END PROGRAM CHAOS
