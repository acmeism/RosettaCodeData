      MODULE ZERMELO	!Approach the foundations of mathematics.
       CONTAINS
        LOGICAL FUNCTION ISINTEGRAL(X)	!A whole number?
         REAL*8 X	!Alas, this is not really a REAL number.
         INTEGER*8 N	!Largest available.
          IF (ISNAN(X)) THEN	!Avoid some sillyness.
            ISINTEGRAL = .FALSE.	!And possible error messages.
          ELSE			!But now it is safe to try.
            N = KIDINT(X)		!This one truncates.
            ISINTEGRAL = N .EQ. X	!Any difference?
          END IF		!A floating-point number may overflow an integer.
        END FUNCTION ISINTEGRAL	!And even if integral, it will not seem so.

        LOGICAL FUNCTION ISINTEGRALZ(Z)	!For complex numbers, two tests.
         DOUBLE COMPLEX Z	!Still not really REAL, though.
          ISINTEGRALZ = ISINTEGRAL(DBLE(Z)) .AND. ISINTEGRAL(DIMAG(Z))	!Separate the parts.
        END FUNCTION ISINTEGRALZ!No INTEGER COMPLEX type is offered.
      END MODULE ZERMELO	!Much more mathematics lie elsewhere.

      PROGRAM TEST
      USE ZERMELO
      DOUBLE COMPLEX Z

      WRITE (6,*) "See if some numbers are integral..."
      WRITE (6,*) ISINTEGRAL(666D0),666D0
      Z = DCMPLX(-3D0,4*ATAN(1D0))
      WRITE (6,*) ISINTEGRALZ(Z),Z
      END
