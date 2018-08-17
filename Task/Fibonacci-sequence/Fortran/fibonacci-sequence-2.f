      FUNCTION IFIB(N)
      IF (N.EQ.0) THEN
        ITEMP0=0
      ELSE IF (N.EQ.1) THEN
        ITEMP0=1
      ELSE IF (N.GT.1) THEN
        ITEMP1=0
        ITEMP0=1
        DO 1 I=2,N
          ITEMP2=ITEMP1
          ITEMP1=ITEMP0
          ITEMP0=ITEMP1+ITEMP2
    1   CONTINUE
      ELSE
        ITEMP1=1
        ITEMP0=0
        DO 2 I=-1,N,-1
          ITEMP2=ITEMP1
          ITEMP1=ITEMP0
          ITEMP0=ITEMP2-ITEMP1
    2   CONTINUE
      END IF
      IFIB=ITEMP0
      END
