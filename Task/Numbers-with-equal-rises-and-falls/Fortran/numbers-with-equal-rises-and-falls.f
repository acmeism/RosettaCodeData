      PROGRAM A296712
          INTEGER IDX, NUM, I
*         Index and number start out at zero
          IDX = 0
          NUM = 0
*         Find and write the first 200 numbers
          WRITE (*,'(A)') 'The first 200 numbers are: '
          DO 100 I = 1, 200
              CALL NEXT NUM(IDX, NUM)
              WRITE (*,'(I4)',ADVANCE='NO') NUM
              IF (MOD(I,20).EQ.0) WRITE (*,*)
  100     CONTINUE
*         Find the 10,000,000th number
          WRITE (*,*)
          WRITE (*,'(A)',ADVANCE='NO') 'The 10,000,000th number is: '
  200     CALL NEXT NUM(IDX, NUM)
          IF (IDX.NE.10000000) GOTO 200
          WRITE (*,'(I8)') NUM
          STOP
      END

*     Given index and current number, retrieve the next number
*     in the sequence.
      SUBROUTINE NEXT NUM(IDX, NUM)
          INTEGER IDX, NUM
          LOGICAL IN SEQ
  100     NUM = NUM + 1
          IF (.NOT. IN SEQ(NUM)) GOTO 100
          IDX = IDX + 1
      END

*     See whether N is in the sequence
      LOGICAL FUNCTION IN SEQ(N)
          INTEGER N, DL, DR, VAL, HEIGHT
*         Get first digit and divide value by 10
          DL = MOD(N, 10)
          VAL = N / 10
          HEIGHT = 0
  100     IF (VAL.NE.0) THEN
*             Retrieve digits by modulo and division
              DR = DL
              DL = MOD(VAL, 10)
              VAL = VAL / 10
*             Record rise or fall
              IF (DL.LT.DR) HEIGHT = HEIGHT + 1
              IF (DL.GT.DR) HEIGHT = HEIGHT - 1
              GOTO 100
          END IF
*         N is in the sequence if the final height is 0
          IN SEQ = HEIGHT.EQ.0
          RETURN
      END
