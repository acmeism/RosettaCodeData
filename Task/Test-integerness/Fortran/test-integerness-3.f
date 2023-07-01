      MODULE ZERMELO	!Approach the foundations of mathematics.
       INTERFACE ISINTEGRAL	!And obscure them with computerese.
        MODULE PROCEDURE ISINTEGRALF4, ISINTEGRALF8,
     1                   ISINTEGRALZ8, ISINTEGRALZ16
       END INTERFACE		!Selection is by parameter type and number.
       CONTAINS			!Sop, now for a grabbag of routines.
        LOGICAL FUNCTION ISINTEGRALF8(X)	!A whole number?
         REAL*8 X	!Alas, this is not really a REAL number.
         INTEGER*8 N	!Largest available.
         INTEGER*8 BIG	!The first number too big to have any fractional digits in floating-point.
         PARAMETER (BIG = RADIX(X)**(DIGITS(X) - 1))	!These "functions" are in fact constants.
          IF (ISNAN(X)) THEN		!Avoid some sillyness.
            ISINTEGRALF8 = .FALSE.	!And possible error messages.
          ELSE IF (ABS(X).GE.BIG) THEN	!But now it is safe to try.
            ISINTEGRALF8 = .TRUE.	!Can't have fractional digits => integral.
          ELSE				!But smaller numbers can have fractional digits.
            N = KIDINT(X)		!So, truncate to an integral value.
            ISINTEGRALF8 = N .EQ. X	!Any difference?
          END IF			!So much for inspection.
        END FUNCTION ISINTEGRALF8	!No need to look at digit sequences.

        LOGICAL FUNCTION ISINTEGRALF4(X)	!A whole number?
         REAL*4 X	!Alas, this is not really a REAL number.
         INTEGER*4 N	!Largest available.
          IF (ISNAN(X)) THEN		!Avoid some sillyness.
            ISINTEGRALF4 = .FALSE.	!And possible error messages.
          ELSE IF (ABS(X) .GE. RADIX(X)**(DIGITS(X) - 1)) THEN	!Constant results as appropriate for X.
            ISINTEGRALF4 = .TRUE.	!Can't have fractional digits => integral.
          ELSE				!But smaller numbers can have fractional digits.
            N = INT(X)			!So, truncate to an integral value.
            ISINTEGRALF4 = N .EQ. X	!Any difference?
          END IF			!A real*4 should not overflow INTEGER*4.
        END FUNCTION ISINTEGRALF4	!Thanks to the size check.

        LOGICAL FUNCTION ISINTEGRALZ8(Z)	!For complex numbers, two tests.
         COMPLEX Z		!Still not really REAL, though.
          ISINTEGRALZ8 = ISINTEGRAL(REAL(Z)) .AND. ISINTEGRAL(AIMAG(Z))	!Separate the parts.
        END FUNCTION ISINTEGRALZ8	!No INTEGER COMPLEX type is offered.

        LOGICAL FUNCTION ISINTEGRALZ16(Z)	!And there are two sorts of complex numbers.
         DOUBLE COMPLEX Z	!Still not really REAL.
          ISINTEGRALZ16 = ISINTEGRAL(DBLE(Z)) .AND. ISINTEGRAL(DIMAG(Z))	!Separate the parts.
        END FUNCTION ISINTEGRALZ16	!No INTEGER COMPLEX type is offered.
      END MODULE ZERMELO	!Much more mathematics lie elsewhere.

      PROGRAM TEST
      USE ZERMELO
      DOUBLE COMPLEX Z
      DOUBLE PRECISION X
      REAL U
Cast forth some pearls.
      WRITE (6,1) 4,DIGITS(U),RADIX(U)
      WRITE (6,1) 8,DIGITS(X),RADIX(X)
    1 FORMAT ("REAL*",I1,":",I3," digits, in base",I2)

      WRITE (6,*) "See if some numbers are integral..."
      WRITE (6,*) ISINTEGRAL(666D0),666D0
      WRITE (6,*) ISINTEGRAL(665.9),665.9
      Z = DCMPLX(-3D0,4*ATAN(1D0))
      WRITE (6,*) ISINTEGRAL(Z),Z
      END
