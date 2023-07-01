      SUBROUTINE PROUST(T)	!Remembrance of time passed.
       INTEGER T		!The time, in seconds. Positive only, please.
       INTEGER NTYPES		!How many types of time?
       PARAMETER (NTYPES = 5)	!This should do.
       INTEGER USIZE(NTYPES)	!Size of the time unit.
       CHARACTER*3 UNAME(NTYPES)!Name of the time unit.
       PARAMETER (USIZE = (/7*24*60*60, 24*60*60, 60*60,   60,    1/))	!The compiler does some arithmetic.
       PARAMETER (UNAME = (/      "wk",      "d",  "hr","min","sec"/))	!Approved names, with trailing spaces.
       CHARACTER*28 TEXT	!A scratchpad.
       INTEGER I,L,N,S		!Assistants.
        S = T			!A copy I can mess with.
        L = 0			!No text has been generated.
        DO I = 1,NTYPES		!Step through the types to do so.
          N = S/USIZE(I)	!Largest first.
          IF (N.GT.0) THEN	!Above the waterline?
            S = S - N*USIZE(I)		!Yes! Remove its contribution.
            IF (L.GT.0) THEN		!Is this the first text to be rolled?
              L = L + 2				!No.
              TEXT(L - 1:L) = ", "		!Cough forth some punctuation.
            END IF			!Now ready for this count.
            WRITE (TEXT(L + 1:),1) N,UNAME(I)	!Place, with the unit name.
    1       FORMAT (I0,1X,A)		!I0 means I only: variable-length, no leading spaces.
            L = LEN_TRIM(TEXT)		!Find the last non-blank resulting.
          END IF			!Since I'm not keeping track.
        END DO			!On to the next unit.
Cast forth the result.
        WRITE (6,*) T,">",TEXT(1:L),"<"	!With annotation.
       END			!Simple enough with integers.

       PROGRAM MARCEL		!Stir the cup.
       CALL PROUST(7259)
       CALL PROUST(7260)
       CALL PROUST(86400)
       CALL PROUST(6000000)
       CALL PROUST(0)
       CALL PROUST(-666)
       END
