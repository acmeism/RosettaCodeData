      PROGRAM LOOPWHILE
        INTEGER I

C       FORTRAN 77 does not have a while loop, so we use GOTO statements
C       with conditions instead. This is one of two easy ways to do it.
        I = 1024
   10   CONTINUE
C       Check condition.
        IF (I .GT. 0) THEN
C         Handle I.
          WRITE (*,*) I
          I = I / 2
C         Jump back to before the IF block.
          GOTO 10
        ENDIF
        STOP
      END
