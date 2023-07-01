      PROGRAM BRAINFORT
Code: ++++++++[>++++[>++>+++>+++>+<<<<-] >+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
      CHARACTER*1 STORE(30000)
      INTEGER D
      STORE = CHAR(0)
      D = 1

      STORE(D) = CHAR(ICHAR(STORE(D)) + 8)
    1   IF (ICHAR(STORE(D)).EQ.0) GO TO 2
        D = D + 1
        STORE(D) = CHAR(ICHAR(STORE(D)) + 4)
    3     IF (ICHAR(STORE(D)).EQ.0) GO TO 4
          D = D + 1
          STORE(D) = CHAR(ICHAR(STORE(D)) + 2)
          D = D + 1
          STORE(D) = CHAR(ICHAR(STORE(D)) + 3)
          D = D + 1
          STORE(D) = CHAR(ICHAR(STORE(D)) + 3)
          D = D + 1
          STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
          D = D - 4
          STORE(D) = CHAR(ICHAR(STORE(D)) - 1)
    4   IF (ICHAR(STORE(D)).NE.0) GO TO 3
        CONTINUE
        D = D + 1
        STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
        D = D + 1
        STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
        D = D + 1
        STORE(D) = CHAR(ICHAR(STORE(D)) - 1)
        D = D + 2
        STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
    5     IF (ICHAR(STORE(D)).EQ.0) GO TO 6
          D = D - 1
    6   IF (ICHAR(STORE(D)).NE.0) GO TO 5
        D = D - 1
        STORE(D) = CHAR(ICHAR(STORE(D)) - 1)
    2 IF (ICHAR(STORE(D)).NE.0) GO TO 1
      D = D + 2
      WRITE (6,'(A1,$)') STORE(D)
      D = D + 1
      STORE(D) = CHAR(ICHAR(STORE(D)) - 3)
      WRITE (6,'(A1,$)') STORE(D)
      STORE(D) = CHAR(ICHAR(STORE(D)) + 7)
      WRITE (6,'(A1,$)') STORE(D)
      WRITE (6,'(A1,$)') STORE(D)
      STORE(D) = CHAR(ICHAR(STORE(D)) + 3)
      WRITE (6,'(A1,$)') STORE(D)
      D = D + 2
      WRITE (6,'(A1,$)') STORE(D)
      D = D - 1
      STORE(D) = CHAR(ICHAR(STORE(D)) - 1)
      WRITE (6,'(A1,$)') STORE(D)
      D = D - 1
      WRITE (6,'(A1,$)') STORE(D)
      STORE(D) = CHAR(ICHAR(STORE(D)) + 3)
      WRITE (6,'(A1,$)') STORE(D)
      STORE(D) = CHAR(ICHAR(STORE(D)) - 6)
      WRITE (6,'(A1,$)') STORE(D)
      STORE(D) = CHAR(ICHAR(STORE(D)) - 8)
      WRITE (6,'(A1,$)') STORE(D)
      D = D + 2
      STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
      WRITE (6,'(A1,$)') STORE(D)
      D = D + 1
      STORE(D) = CHAR(ICHAR(STORE(D)) + 2)
      WRITE (6,'(A1,$)') STORE(D)
      END
