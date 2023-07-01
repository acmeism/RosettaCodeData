      DO I = FIRST,LAST
        IF (PROGRESSNOTE((I - FIRST)/(LAST - FIRST + 1.0))) WRITE (6,*) "Reached ",I,", towards ",LAST
        ...much computation...
      END DO
