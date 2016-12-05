      INTEGER*4 I,TEXT(66)
      DATA TEXT(1),TEXT(2),TEXT(3)/"Wo","rl","d!"/

      WRITE (6,1) (TEXT(I), I = 1,3)
    1 FORMAT ("Hello ",66A2)

      DO 2 I = 1,3
    2   TEXT(I + 3) = TEXT(I)
      TEXT(1) = "He"
      TEXT(2) = "ll"
      TEXT(3) = "o "

      WRITE (6,3) (TEXT(I), I = 1,6)
    3 FORMAT (66A2)
      END
