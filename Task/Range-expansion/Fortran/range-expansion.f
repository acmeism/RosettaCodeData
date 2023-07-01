      MODULE HOMEONTHERANGE
       CONTAINS	!The key function.
        CHARACTER*200 FUNCTION ERANGE(TEXT)	!Expands integer ranges in a list.
Can't return a character value of variable size.
         CHARACTER*(*) TEXT	!The list on input.
         CHARACTER*200 ALINE	!Scratchpad for output.
         INTEGER N,N1,N2	!Numbers in a range.
         INTEGER I,I1		!Steppers.
          ALINE = ""		!Scrub the scratchpad.
          L = 0			!No text has been placed.
          I = 1			!Start at the start.
          CALL FORASIGN		!Find something to look at.
Chug through another number or number - number range.
        R:DO WHILE(EATINT(N1))	!If I can grab a first number, a term has begun.
            N2 = N1			!Make the far end the same.
            IF (PASSBY("-")) CALL EATINT(N2)	!A hyphen here is not a minus sign.
            IF (L.GT.0) CALL EMIT(",")		!Another, after what went before?
            DO N = N1,N2,SIGN(+1,N2 - N1)	!Step through the range, possibly backwards.
              CALL SPLOT(N)				!Roll a number.
              IF (N.NE.N2) CALL EMIT(",")		!Perhaps another follows.
            END DO				!On to the next number.
            IF (.NOT.PASSBY(",")) EXIT R	!More to come?
          END DO R		!So much for a range.
Completed the scan. Just return the result.
          ERANGE = ALINE(1:L)	!Present the result. Fiddling ERANGE is bungled by some compilers.
         CONTAINS	!Some assistants for the scan to save on repetition and show intent.
          SUBROUTINE FORASIGN	!Look for one.
    1       IF (I.LE.LEN(TEXT)) THEN	!After a thingy,
              IF (TEXT(I:I).LE." ") THEN	!There may follow spaces.
                I = I + 1				!So,
                GO TO 1					!Speed past any.
              END IF			!So that the caller can see
            END IF			!Whatever substantive character follows.
          END SUBROUTINE FORASIGN	!Simple enough.

          LOGICAL FUNCTION PASSBY(C)	!Advances the scan if a certain character is seen.
Could consider or ignore case for letters, but this is really for single symbols.
           CHARACTER*1 C	!The character.
            PASSBY = .FALSE.	!Pessimism.
            IF (I.LE.LEN(TEXT)) THEN	!Can't rely on I.LE.LEN(TEXT) .AND. TEXT(I:I)...
              IF (TEXT(I:I).EQ.C) THEN	!Curse possible full evaluation.
                PASSBY = .TRUE.		!Righto, C is seen.
                I = I + 1		!So advance the scan.
                CALL FORASIGN		!And see what follows.
              END IF		!So much for a match.
            END IF		!If there is something to be uinspected.
          END FUNCTION PASSBY	!Can't rely on testing PASSBY within PASSBY either.

          LOGICAL FUNCTION EATINT(N)	!Convert text into an integer.
           INTEGER N	!The value to be ascertained.
           INTEGER D	!A digit.
           LOGICAL NEG	!In case of a minus sign.
            EATINT = .FALSE.	!Pessimism.
            IF (I.GT.LEN(TEXT)) RETURN	!Anything to look at?
            N = 0			!Scrub to start with.
            IF (PASSBY("+")) THEN	!A plus sign here can be ignored.
              NEG = .FALSE.		!So, there's no minus sign.
             ELSE			!And if there wasn't a plus,
              NEG = PASSBY("-")		!A hyphen here is a minus sign.
            END IF			!One way or another, NEG is initialised.
            IF (I.GT.LEN(TEXT)) RETURN	!Nothing further! We wuz misled!
Chug through digits. Can develop -2147483648, thanks to the workings of two's complement.
   10       D = ICHAR(TEXT(I:I)) - ICHAR("0")	!Hope for a digit.
            IF (0.LE.D .AND. D.LE.9) THEN	!Is it one?
              N = N*10 + D			!Yes! Assimilate it, negatively.
              I = I + 1				!Advance one.
              IF (I.LE.LEN(TEXT)) GO TO 10	!And see what comes next.
            END IF			!So much for a sequence of digits.
            IF (NEG) N = -N		!Apply the minus sign.
            EATINT = .TRUE.		!Should really check for at least one digit.
            CALL FORASIGN		!Ram into whatever follows.
          END FUNCTION EATINT	!Integers are easy. Could check for no digits seen.

          SUBROUTINE EMIT(C)	!Rolls forth one character.
           CHARACTER*1 C	!The character.
            L = L + 1		!Advance the finger.
            IF (L.GT.LEN(ALINE)) STOP "Ran out of ALINE!"	!Maybe not.
            ALINE(L:L) = C	!And place the character.
          END SUBROUTINE EMIT	!That was simple.

          SUBROUTINE SPLOT(N)	!Rolls forth a signed number.
           INTEGER N		!The number.
           CHARACTER*12 FIELD	!Sufficient for 32-bit integers.
           INTEGER I		!A stepper.
            WRITE (FIELD,"(I0)") N	!Roll the number, with trailing spaces.
            DO I = 1,12		!Now transfer the ALINE of the number.
              IF (FIELD(I:I).LE." ") EXIT	!Up to the first space.
              CALL EMIT(FIELD(I:I))	!One by one.
            END DO		!On to the end.
          END SUBROUTINE SPLOT	!Not so difficult either.
        END FUNCTION ERANGE	!A bit tricky.
      END MODULE HOMEONTHERANGE

      PROGRAM POKE
      USE HOMEONTHERANGE
      CHARACTER*(200) SOME
      SOME = "-6,-3--1,3-5,7-11,14,15,17-20"
      SOME = ERANGE(SOME)
      WRITE (6,*) SOME	!If ERANGE(SOME) then the function usually can't write output also.
      END
