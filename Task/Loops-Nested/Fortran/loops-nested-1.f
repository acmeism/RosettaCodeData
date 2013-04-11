      PROGRAM LOOPNESTED
        INTEGER A, I, J, RNDINT

C       Build a two-dimensional twenty-by-twenty array.
        DIMENSION A(20,20)

C       It doesn't matter what number you put here.
        CALL SDRAND(123)

C       Fill the array with random numbers.
        DO 20 I = 1, 20
          DO 10 J = 1, 20
            A(I, J) = RNDINT(1, 20)
   10     CONTINUE
   20   CONTINUE

C       Print the numbers.
        DO 40 I = 1, 20
          DO 30 J = 1, 20
            WRITE (*,5000) I, J, A(I, J)

C           If this number is twenty, break out of both loops.
            IF (A(I, J) .EQ. 20) GOTO 50
   30     CONTINUE
   40   CONTINUE

C       If we had gone to 40, the DO loop would have continued. You can
C       label STOP instead of adding another CONTINUE, but it is good
C       form to only label CONTINUE statements as much as possible.
   50   CONTINUE
        STOP

C       Print the value so that it looks like one of those C arrays that
C       makes everybody so comfortable.
 5000   FORMAT('A[', I2, '][', I2, '] is ', I2)
      END

C FORTRAN 77 does not have come with a random number generator, but it
C is easy enough to type "fortran 77 random number generator" into your
C preferred search engine and to copy and paste what you find. The
C following code is a slightly-modified version of:
C
C     http://www.tat.physik.uni-tuebingen.de/
C         ~kley/lehre/ftn77/tutorial/subprograms.html
      SUBROUTINE SDRAND (IRSEED)
        COMMON  /SEED/ UTSEED, IRFRST
        UTSEED = IRSEED
        IRFRST = 0
        RETURN
      END
      INTEGER FUNCTION RNDINT (IFROM, ITO)
        INTEGER IFROM, ITO
        PARAMETER (MPLIER=16807, MODLUS=2147483647,                     &
     &              MOBYMP=127773, MOMDMP=2836)
        COMMON  /SEED/ UTSEED, IRFRST
        INTEGER HVLUE, LVLUE, TESTV, NEXTN
        SAVE    NEXTN
        IF (IRFRST .EQ. 0) THEN
          NEXTN = UTSEED
          IRFRST = 1
        ENDIF
        HVLUE = NEXTN / MOBYMP
        LVLUE = MOD(NEXTN, MOBYMP)
        TESTV = MPLIER*LVLUE - MOMDMP*HVLUE
        IF (TESTV .GT. 0) THEN
          NEXTN = TESTV
        ELSE
          NEXTN = TESTV + MODLUS
        ENDIF
        IF (NEXTN .GE. 0) THEN
          RNDINT = MOD(MOD(NEXTN, MODLUS), ITO - IFROM + 1) + IFROM
        ELSE
          RNDINT = MOD(MOD(NEXTN, MODLUS), ITO - IFROM + 1) + ITO + 1
        ENDIF
        RETURN
      END
