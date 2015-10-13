      INTEGER IV
      REAL V
      DATA V/7.125/	!A positive number.
      IV = V		!Grab the integer part.
      WRITE (6,1) V,IV
    1 FORMAT (F9.3,T1,I5.5)
      END
