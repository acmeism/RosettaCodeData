      PROGRAM LOOPWHILE
      INTEGER I
C     FORTRAN 66 does not have IF block.
      I = 1024
 10   CONTINUE
      IF (I .LE. 0) GOTO 20
      WRITE (*,*) I
      I = I / 2
      GOTO 10
 20   CONTINUE
      STOP
      END
