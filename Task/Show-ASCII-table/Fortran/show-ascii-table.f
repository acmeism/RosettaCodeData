       PROGRAM ASCTBL  ! show the ASCII characters from 32-127
       IMPLICIT NONE
       INTEGER I, J
       CHARACTER*3 H

  10   FORMAT (I3, ':', A3, '   ', $)
  20   FORMAT ()
       DO J = 0, 15, +1
         DO I = 32+J, 127, +16
           IF (I > 32 .AND. I < 127) THEN
             H = ' ' // ACHAR(I) // ' '
           ELSE IF (I .EQ. 32) THEN
             H = 'Spc'
           ELSE IF (I .EQ. 127) THEN
             H = 'Del'
           ELSE
             STOP 'bad value of i'
           END IF
           PRINT 10, I, H
         END DO
         PRINT 20
       END DO

       END
