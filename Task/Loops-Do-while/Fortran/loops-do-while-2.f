      PROGRAM DOWHILE
C Initialize modulus and value.
        INTEGER MODLUS, IVALUE
        PARAMETER (MODLUS = 6)
        IVALUE = 0

C FORTRAN 77 has no do-while structure -- not semantically. It is not
C difficult to simulate it using GOTO, however:
   10   CONTINUE
          IVALUE = IVALUE + 1
          WRITE (*,*) IVALUE
        IF (.NOT. (MOD(IVALUE, MODLUS) .EQ. 0)) GOTO 10

        STOP
      END
