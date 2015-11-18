Calculate various trigonometric functions from the Fortran library.
      INTEGER BIT(32),B,IP	!Stuff for bit fiddling.
      INTEGER ENUFF,I		!Step through the test angles.
      PARAMETER (ENUFF = 17)	!A selection of special values.
      INTEGER ANGLE(ENUFF)	!All in whole degrees.
      DATA ANGLE/0,30,45,60,90,120,135,150,180,	!Here they are.
     1 210,225,240,270,300,315,330,360/		!Thus check angle folding.
      REAL PI,DEG2RAD		!Special numbers.
      REAL D,R,FD,FR,AD,AR	!Degree, Radian, F(D), F(R), inverses.
      PI = 4*ATAN(1.0)		!SINGLE PRECISION 1·0.
      DEG2RAD = PI/180		!Limited precision here too for a transcendental number.
Case the first: sines.
      WRITE (6,10) ("Sin", I = 1,4)	!Supply some names.
   10 FORMAT (" Deg.",A7,"(Deg)",A7,"(Rad)   Rad - Deg",	!Ah, layout.
     1 6X,"Arc",A3,"D",6X,"Arc",A3,"R",9X,"Diff")
      DO I = 1,ENUFF		!Step through the test values.
        D = ANGLE(I)			!The angle in degrees, in floating point.
        R = D*DEG2RAD			!Approximation, in radians.
        FD = SIND(D); AD = ASIND(FD)		!Functions working in degrees.
        FR = SIN(R);  AR = ASIN(FR)/DEG2RAD	!Functions working in radians.
        WRITE (6,11) INT(D),FD,FR,FR - FD,AD,AR,AR - AD	!Results.
   11   FORMAT (I4,":",3F12.8,3F13.7)	!Ah, alignment with FORMAT 10...
      END DO			!On to the next test value.
Case the second: cosines.
      WRITE (6,10) ("Cos", I = 1,4)
      DO I = 1,ENUFF
        D = ANGLE(I)
        R = D*DEG2RAD
        FD = COSD(D); AD = ACOSD(FD)
        FR = COS(R);  AR = ACOS(FR)/DEG2RAD
        WRITE (6,11) INT(D),FD,FR,FR - FD,AD,AR,AR - AD
      END DO
Case the third: tangents.
      WRITE (6,10) ("Tan", I = 1,4)
      DO I = 1,ENUFF
        D = ANGLE(I)
        R = D*DEG2RAD
        FD = TAND(D); AD = ATAND(FD)
        FR = TAN(R);  AR = ATAN(FR)/DEG2RAD
        WRITE (6,11) INT(D),FD,FR,FR - FD,AD,AR,AR - AD
      END DO
      WRITE (6,*) "...Special deal for 90 degrees..."
      D = 90
      R = D*DEG2RAD
      FD = TAND(D); AD = ATAND(FD)
      FR = TAN(R);  AR = ATAN(FR)/DEG2RAD
      WRITE (6,*) "TanD =",FD,"Atan =",AD
      WRITE (6,*) "TanR =",FR,"Atan =",AR
Convert PI to binary...
      PI = PI - 3	!I know it starts with three, and I need the fractional part.
      BIT(1:2) = 1	!So, the binary is 11. something.
      B = 2		!Two bits known.
      DO I = 1,26	!For single precision, more than enough additional bits.
        PI = PI*2		!Hoist a bit to the hot spot.
        IP = PI			!The integral part.
        PI = PI - IP		!Remove it from the work in progress.
        B = B + 1		!Another bit bitten.
        BIT(B) = IP		!Place it.
      END DO		!On to the next.
      WRITE (6,20) BIT(1:B)	!Reveal the bits.
   20 FORMAT (" Pi ~ ",2I1,".",66I1)	!A known format.
      WRITE (6,*) "   = 11.00100100001111110110101010001000100001..."	!But actually...
      END		!So much for that.
