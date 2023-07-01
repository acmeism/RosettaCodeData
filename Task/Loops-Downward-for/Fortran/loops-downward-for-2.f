      PROGRAM DOWNWARDFOR
C Initialize the loop parameters.
        INTEGER I, START, FINISH, STEP
        PARAMETER (START = 10, FINISH = 0, STEP = -1)

C If you were to leave off STEP, it would default to positive one.
        DO 10 I = START, FINISH, STEP
          WRITE (*,*) I
   10   CONTINUE

        STOP
      END
