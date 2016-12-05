MODULE Simulation

   IMPLICIT NONE

   CONTAINS

   FUNCTION Pi(samples)
     REAL :: Pi
     REAL :: coords(2), length
     INTEGER :: i, in_circle, samples

     in_circle = 0
     DO i=1, samples
       CALL RANDOM_NUMBER(coords)
       coords = coords * 2 - 1
       length = SQRT(coords(1)*coords(1) + coords(2)*coords(2))
       IF (length <= 1) in_circle = in_circle + 1
     END DO
     Pi = 4.0 * REAL(in_circle) / REAL(samples)
   END FUNCTION Pi

 END MODULE Simulation

 PROGRAM MONTE_CARLO

   USE Simulation

   INTEGER :: n = 10000

   DO WHILE (n <= 100000000)
     WRITE (*,*) n, Pi(n)
     n = n * 10
   END DO

 END PROGRAM MONTE_CARLO
