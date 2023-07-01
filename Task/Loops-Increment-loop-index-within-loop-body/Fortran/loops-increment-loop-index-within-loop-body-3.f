C LOOPS INCREMENT LOOP INDEX WITHIN LOOP BODY - 17/07/2018
      IMAX=25
      I=0
      N=42
  10  IF(I.GE.IMAX)GOTO 30
        IF(ISPRIME(N).NE.1)GOTO 20
          I=I+1
          WRITE(*,301) I,N
 301      FORMAT(I2,1X,I10)
          N=N+N-1
  20    N=N+1
      GOTO 10
  30  CONTINUE
      END

      FUNCTION ISPRIME(M)
        IF(M.NE.2 .AND. M.NE.3)GOTO 10
          ISPRIME=1
          RETURN
  10    IF(MOD(M,2).NE.0 .AND. MOD(M,3).NE.0)GOTO 20
          ISPRIME=0
          RETURN
  20      I=5
  30      IF(I*I.GT.M)GOTO 50
            IF(MOD(M,I).NE.0 .AND. MOD(M,I+2).NE.0)GOTO 40
              ISPRIME=0
              RETURN
  40        I=I+6
          GOTO 30
  50      ISPRIME=1
          RETURN
      END
