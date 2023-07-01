      SUBROUTINE SPLATTER(TEXT)	!Print a comma-separated list. Repeated characters constitute one item.
Can't display the inserted commas in a different colour so as not to look like any commas in TEXT.
       CHARACTER*(*) TEXT	!The text.
       INTEGER L	!A finger.
       CHARACTER*1 C	!A state follower.
        IF (LEN(TEXT).LE.0) RETURN	!Prevent surprises in the following..
        C = TEXT(1:1)			!Syncopation: what went before.
        DO L = 1,LEN(TEXT)	!Step through the text.
          IF (C.NE.TEXT(L:L)) THEN	!A change of character?
            C = TEXT(L:L)			!Yes. This is the new normal.
            WRITE (6,1) ", "			!Set off from what went before. This is not from TEXT.
          END IF			!So much for changes.
          WRITE (6,1) C			!Roll the current character. (=TEXT(L:L))
    1     FORMAT (A,$)			!The $ sez: do not end the line.
        END DO			!On to the next character.
        WRITE (6,1)	!Thus end the line. No output item means that the $ is not reached, so the line is ended.
      END SUBROUTINE SPLATTER	!TEXT with spaces, or worse, commas, will produce an odd-looking list.

      PROGRAM POKE
      CALL SPLATTER("gHHH5YY++///\")	!The example given.
      END
