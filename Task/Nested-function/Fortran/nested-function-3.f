      SUBROUTINE POOBAH(TEXT,N,SEP)	!I've got a little list!
       CHARACTER*(*) TEXT(*)	!The supplied scratchpad.
       INTEGER N		!Entry count.
       CHARACTER*(*) SEP	!The separator to be used.
        N = 0			!No items added.
        CALL ADDITEM("first")	!Here we go.
        CALL ADDITEM("second")
        CALL ADDITEM("third")
       CONTAINS		!Madly, defined after usage.
        SUBROUTINE ADDITEM(X)	!A contained routine.
         CHARACTER*(*) X	!The text of the item to add.
          N = N + 1			!Count another item in.
          WRITE (TEXT(N),1) N,SEP,X	!Place the N'th text, suitably decorated..
    1     FORMAT (I1,2A)		!Allowing only a single digit.
        END SUBROUTINE ADDITEM	!That was simple.
      END SUBROUTINE POOBAH	!Still worth a subroutine.

      PROGRAM POKE
      CHARACTER*28 TEXT(9)	!Surely sufficient.
      INTEGER N
      CALL POOBAH(TEXT,N,". ")
      WRITE (6,"(A)") (TEXT(I)(1:LEN_TRIM(TEXT(I))), I = 1,N)
      END
