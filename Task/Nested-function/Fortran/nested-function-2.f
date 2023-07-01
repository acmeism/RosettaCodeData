      SUBROUTINE POOBAH(TEXT,L,SEP)	!I've got a little list!
       CHARACTER*(*) TEXT	!The supplied scratchpad.
       INTEGER L		!Its length.
       CHARACTER*(*) SEP	!The separator to be used.
       INTEGER N		!A counter.
        L = 0			!No text is in place.
        N = 0			!No items added.
        CALL ADDITEM("first")	!Here we go.
        CALL ADDITEM("second")
        CALL ADDITEM("third")
       CONTAINS		!Madly, defined after usage.
        SUBROUTINE ADDITEM(X)	!A contained routine.
         CHARACTER*(*) X	!The text of the item.
          N = N + 1			!Count another item in.
          TEXT(L + 1:L + 1) = CHAR(ICHAR("0") + N)	!Place the single-digit number.
          L = L + 1			!Rather than mess with unknown-length numbers.
          LX = LEN(SEP)			!Now for the separator.
          TEXT(L + 1:L + LX) = SEP	!Placed.
          L = L + LX			!Advance the finger.
          LX = LEN(X)			!Trailing spaces will be included.
          TEXT(L + 1:L + LX) = X	!Placed.
          L = L + LX			!Advance the finger.
          L = L + 1			!Finally,
          TEXT(L:L) = CHAR(10)		!Append an ASCII line feed. Starts a new line.
        END SUBROUTINE ADDITEM	!That was bitty.
      END SUBROUTINE POOBAH	!But only had to be written once.

      PROGRAM POKE
      CHARACTER*666 TEXT	!Surely sufficient.
      INTEGER L
      CALL POOBAH(TEXT,L,". ")
      WRITE (6,"(A)") TEXT(1:L)
      END
