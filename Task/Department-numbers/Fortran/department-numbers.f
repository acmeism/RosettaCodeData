      INTEGER P,S,F	!Department codes for Police, Sanitation, and Fire. Values 1 to 7 only.
    1  PP:DO P = 2,7,2	!The police demand an even number. They're special and use violence.
    2   SS:DO S = 1,7		!The sanitation department accepts any value.
    3        IF (P.EQ.S) CYCLE SS	!But it must differ from the others.
    4        F = 12 - (P + S)		!The fire department accepts any number, but the sum must be twelve.
    5        IF (F.LE.0 .OR. F.GT.7) CYCLE SS	!Ensure that the only option is within range.
    6        IF ((F - S)*(F - P)) 7,8,7		!And F is to differ from S and from P
    7        WRITE (6,"(3I2)") P,S,F		!If we get here, we have a possible set.
    8      END DO SS		!Next S
    9    END DO PP	!Next P.
      END	!Well, that was straightforward.
