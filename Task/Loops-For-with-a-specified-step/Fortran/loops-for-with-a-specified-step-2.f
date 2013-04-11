      PROGRAM STEPFOR
        INTEGER I

C       This will print all even numbers from -10 to +10, inclusive.
        DO 10 I = -10, 10, 2
          WRITE (*,*) I
   10   CONTINUE

        STOP
      END
