      DIMENSION ATWT(12)
      PRINT 1
    1 FORMAT (12HElement Name,F9.4)
      DO 10 I = 1,12
        READ  1,ATWT(I)
   10   PRINT 1,ATWT(I)
      END
