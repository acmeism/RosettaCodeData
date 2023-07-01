        SUBROUTINE BIGWRITE(F,B)	!Show B.
         INTEGER F	!I/O unit number.
         TYPE(BIGNUM) B	!The number.
          WRITE (F,1,ADVANCE="NO") B.DIGIT(B.LAST:1:-1)	!Roll the digits in base BIGBASE.
    1     FORMAT (666(I0:"."))		!Not bothering with using letters for digits above nine.
        END SUBROUTINE BIGWRITE		!Simple, but messy.

        SUBROUTINE BIGTEN(B,TEXT)	!Produce a base ten digit string.
         TYPE(BIGNUM) B		!The number.
         CHARACTER*(*) TEXT	!The digits.
         TYPE(BIGNUM) N		!A copy I can mess with.
         INTEGER L,D		!Assistants.
          N.LAST = B.LAST	!So, make my copy.
          N.DIGIT(1:N.LAST) = B.DIGIT(1:B.LAST)	!Only the live digits are wanted.
          TEXT = ""		!Clear for action.
          L = LEN(TEXT)		!Find the far end.
   10     D = BIGDIVRN(N,10)	!Digits emerge from the low-order end of the number.
          TEXT(L:L) = CHAR(ICHAR("0") + D)	!Convert a digit to text, usual assumptions.
          IF (N.LAST.EQ.1 .AND. N.DIGIT(1).EQ.0) RETURN	!If zero, N is finished.
          L = L - 1		!Otherwise, another digits will emerge.
          IF (L.GT.0) GO TO 10	!If there is space, go for it.
          TEXT(1:1) = "!"	!Otherwise, signify overflow.
        END SUBROUTINE BIGTEN	!No negatives, so no sign is needed.

        LOGICAL FUNCTION BIGISPRIME(B)	!Ad-hoc report.
         TYPE(BIGNUM) B	!The number.
          BIGISPRIME = ABS(BIGFACTOR(B,2800)).EQ.1	!Condensed report.
        END FUNCTION BIGISPRIME	!Can't be bothered with ISPRIME from PRIMEBAG.
