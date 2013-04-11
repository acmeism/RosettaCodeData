      PROGRAM LOOPBREAK
        INTEGER I, RNDINT

C       It doesn't matter what number you put here.
        CALL SDRAND(123)

C       Because FORTRAN 77 semantically lacks many loop structures, we
C       have to use GOTO statements to do the same thing.
   10   CONTINUE
C         Print a random number.
          I = RNDINT(0, 19)
          WRITE (*,*) I

C         If the random number is ten, break (i.e. skip to after the end
C         of the "loop").
          IF (I .EQ. 10) GOTO 20

C         Otherwise, print a second random number.
          I = RNDINT(0, 19)
          WRITE (*,*) I

C         This is the end of our "loop," meaning we jump back to the
C         beginning again.
          GOTO 10

   20   CONTINUE

        STOP
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
