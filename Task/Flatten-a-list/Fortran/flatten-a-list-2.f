      SUBROUTINE CRUSH(LIST)	!Changes LIST.
Crushes a list holding multi-level entries within [...] to a list of single-level entries. Null entries are purged.
Could escalate to recognising quoted strings as list entries (preserving spaces), not just strings of digits.
       CHARACTER*(*) LIST	!The text manifesting the list.
       INTEGER I,L		!Fingers.
       LOGICAL LIVE		!Scan state.
        L = 1		!Output finger. The starting [ is already in place.
        LIVE = .FALSE.	!A list element is not in progress.
        DO I = 2,LEN(LIST)	!Scan the characters of the list.
          SELECT CASE(LIST(I:I))	!Consider one.
           CASE("[","]",","," ")	!Punctuation or spacing?
            IF (LIVE) THEN		!Yes. If previously in an element,
              L = L + 1			!Advance the finger,
              LIST(L:L) = ","		!And place its terminating comma.
              LIVE = .FALSE.		!Thus the element is finished.
            END IF		!So much for punctuation and empty space.
           CASE DEFAULT		!Everything else is an element's content.
            LIVE = .TRUE.		!So we're in an element.
            L = L + 1			!Advance the finger.
            LIST(L:L) = LIST(I:I)	!And copy the content's character.
          END SELECT		!Either we're in an element, or, we're not.
        END DO			!On to the next character.
Completed the crush. At least one ] must have followed the last character of the last element.
        LIST(L:L) = "]"		!It had provoked a trailing comma. Now it is the ending ].
        LIST(L + 1:) = ""	!Scrub any tail end, just to be neat.
      END		!Trailing spaces are the caller's problem.

      CHARACTER*88 STUFF	!Work area.
      STUFF = "[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]"	!The example.
      WRITE (6,*) "Original: ",STUFF
      CALL CRUSH(STUFF)		!Can't be a constant, as it will be changed.
      WRITE (6,*) " Crushed: ",STUFF	!Behold!
      END
