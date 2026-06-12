      REAL FUNCTION TRUNC6(X) 	!Truncate X to six-digit decimal precision.
       REAL X	 !The number.
       REAL A	 !Its base ten log.
       REAL P	 !Its fractional part.
       REAL T	 !A scratchpad.
       INTEGER I,IP 	!For playing with powers of ten.
        IF (ISNAN(X)) THEN	!Avoid complaints from LOG10.
          TRUNC6 = X		!I'm not bothering with infinity.
        ELSE IF (X.EQ.0) THEN	!But a zero is quite possible.
          TRUNC6 = 0		!And provokes LOG10.
        ELSE		!But, this is the expectation.
          A = ABS(X)		!Simplify.
          A = LOG10(A)		!Convert to base ten, whatever X is in.
          IP = A		!Get the integer part of the log.
          P = A - IP		!Remove some power of ten.
          IF (P.LT.0) THEN	!Values of X less than one have a negative log.
            IP = IP - 1		!But I want the log table style.
            P = P + 1		!With positive fractional part.
          END IF		!X = 10**(IP + P), where P is in [0,1).
          I = 10**(P + 5)	!10**(5.30103) = 200000.00stuff. Six significant digits.
          IP = IP - 5  		!The countervailing power of ten.
          IF (IP.LT.0) THEN	!If less than zero, divide by a fp number to avoid integer division.
            T = I/10.0D0**(-IP)	!Remember that 0·1 and associates are approximations in binary.
          ELSE IF (IP.GT.0) THEN!But if greater than zero,
            T = I*10**IP	!Positive powers of ten are integers and exact.
          ELSE			!And if the power were zero, no worries.
            T = I		!Just take the integer.
          END IF		!So much for shifting and counter-shifting.
          TRUNC6 = SIGN(T,X)	!Return the original sign.
        END IF		 !That was a struggle.
      END	 !The result is still a binary floating-point number.

      REAL FUNCTION ROUND6(X)	!Rely on the formatting system.
       REAL X			!The number.
       CHARACTER*16 TEXT	 !Sufficient for "-0.123456E+666".
        WRITE (TEXT,1) X	 !Out it goes.
    1   FORMAT (E16.6)		 !With rounding to six significant digits.
        READ (TEXT,*) ROUND6	 !Get it back.
      END			 !All the hard work is done by the format routines.

      REAL FUNCTION SUMC6(A,N)	!Add elements of the array, using limited precision.
Compensated summation. C will not stay zero, despite mathematics.
       REAL A(N)	 !The array. Presumably with at least one element.
       INTEGER N	 !The number of elements.
       REAL S,C,Y,T	 !Assistants.
       INTEGER I	 !A stepper.
        S = A(1)	 !Start with the first element.
        C = 0.0		 !No previous omissions to carry forward.
        DO I = 2,N	!Step through the remainder of the array.
          Y = ROUND6(A(I) - C)		!Combine the next value with the compensation.
          T = ROUND6(S + Y)		!Augment the sum in T.
          C = ROUND6(ROUND6(T - S) - Y)	!Catch what part of Y didn't get added to T.
          S = T				!Place the sum.
        END DO		!On to the next element.
        SUMC6 = S	!C will no longer be zero.
      END		!Using a working mean might help.

      REAL A(3)
      A(1) = 10000.0
      A(2) = 3.14159
      A(3) = 2.71828
      WRITE (6,1) "S",ROUND6(ROUND6(A(1) + A(2)) + A(3))
      WRITE (6,1) "C",SUMC6(A,3)
    1 FORMAT (A1,"Sum = ",F12.1)
      END
