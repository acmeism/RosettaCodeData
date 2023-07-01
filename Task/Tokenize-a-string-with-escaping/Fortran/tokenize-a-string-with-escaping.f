      SUBROUTINE SPLIT(TEXT,SEP,ESC)	!Identifies and prints tokens from within a text.
       CHARACTER*(*) TEXT	!To be scanned.
       CHARACTER*(1) SEP	!The only separator for tokens.
       CHARACTER*(1) ESC	!Miscegnator.
       CHARACTER*(LEN(TEXT)) TOKEN	!Surely sufficient space.
       INTEGER N	!Counts the tokens as they're found.
       INTEGER I	!Steps through the text.
       INTEGER L	!Length of the token so far accumulated.
       LOGICAL ESCAPING	!Miscegnatory state.
        N = 0		!No tokens so far.
        L = 0		!Nor any text for the first.
        ESCAPING = .FALSE.	!And the state is good.
        DO I = 1,LEN(TEXT)	!Step through the text.
          IF (ESCAPING) THEN	!Are we in a mess?
            L = L + 1			!Yes. An ESC character had been seen.
            TOKEN(L:L) = TEXT(I:I)	!So, whatever follows is taken as itself.
            ESCAPING = .FALSE.		!There are no specially-recognised names.
           ELSE			!Otherwise, we're in text to inspect.
            IF (TEXT(I:I).EQ.ESC) THEN	!So, is it a troublemaker?
             ESCAPING = .TRUE.			!Yes! Trouble is to follow.
            ELSE IF (TEXT(I:I).EQ.SEP) THEN	!If instead a separator,
             CALL SPLOT				!Then the token up to it is complete.
            ELSE			!Otherwise, a simple constituent character.
             L = L + 1				!So, count it in.
             TOKEN(L:L) = TEXT(I:I)		!And copy it in.
            END IF			!So much for grist.
          END IF		!So much for that character.
        END DO			!On to the next.
Completes on end-of-text with L > 0, or, if the last character had been SEP, a null token is deemed to be following.
        CALL SPLOT	!Tail end.
       CONTAINS	!Save on having two copies of this code.
        SUBROUTINE SPLOT	!Show the token and scrub.
         N = N + 1			!Another one.
         WRITE (6,1) N,TOKEN(1:L)	!Reveal.
    1    FORMAT ("Token ",I0," >",A,"<")!Fancy layout.
         L = 0				!Prepare for a fresh token.
        END SUBROUTINE SPLOT	!A brief life.
      END SUBROUTINE SPLIT	!And then oblivion.

      PROGRAM POKE

      CALL SPLIT("one^|uno||three^^^^|four^^^|^cuatro|","|","^")

      END
