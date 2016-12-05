      CHARACTER*12345 TEXT
       ...
      DO I = 0,120
        WRITE (6,*) TEXT(I*80 + 1:(I + 1)*80)
      END DO
