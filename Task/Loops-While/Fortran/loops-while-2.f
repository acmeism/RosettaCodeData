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

C       This is an alternative while loop with labels on both ends. This
C       will use the condition as a break rather than create an entire
C       IF block. Which you use is up to you, but be aware that you must
C       use this one if you plan on allowing for breaks.
        I = 1024
   20   CONTINUE
C         If condition is false, break.
          IF (I .LE. 0) GOTO 30
C         Handle I.
          WRITE (*,*) I
          I = I / 2
C         Jump back to the "loop" beginning.
          GOTO 20
   30   CONTINUE

        STOP
      END
