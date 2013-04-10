PROGRAM YULETIDE

IMPLICIT NONE

INTEGER :: day, year

WRITE(*, "(A)", ADVANCE="NO") "25th of December is a Sunday in"
DO year = 2008, 2121
   day = Day_of_week(25, 12, year)
   IF (day == 1) WRITE(*, "(I5)", ADVANCE="NO") year
END DO

CONTAINS

FUNCTION Day_of_week(d, m, y)
   INTEGER :: Day_of_week, j, k, mm, yy
   INTEGER, INTENT(IN) :: d, m, y

   mm=m
   yy=y
   IF(mm.le.2) THEN
      mm=mm+12
      yy=yy-1
   END IF
   j = yy / 100
   k = MOD(yy, 100)
   Day_of_week = MOD(d + ((mm+1)*26)/10 + k + k/4 + j/4 + 5*j, 7)
END FUNCTION Day_of_week

END PROGRAM YULETIDE
