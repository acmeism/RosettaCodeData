      SUBROUTINE AFFIRM(CONDITION,MESSAGE)
        LOGICAL CONDITION
        CHARACTER*(*) MESSAGE
         IF (CONDITION) RETURN      !All is well.
         WRITE (6,*) MESSAGE
         STOP "Oops. Confusion!"
       END
