      SUBROUTINE UPCASE(TEXT)
       CHARACTER*(*) TEXT
       INTEGER I,C
        DO I = 1,LEN(TEXT)
          C = INDEX("abcdefghijklmnopqrstuvwxyz",TEXT(I:I))
          IF (C.GT.0) TEXT(I:I) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"(C:C)
        END DO
      END
