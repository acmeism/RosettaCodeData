      SUBROUTINE IRANGE(TEXT)	!Identifies integer ranges in a list of integers.
Could make this a function, but then a maximum text length returned would have to be specified.
       CHARACTER*(*) TEXT	!The list on input, the list with ranges on output.
       INTEGER LOTS		!Once again, how long is a piece of string?
       PARAMETER (LOTS = 666)	!This should do, at least for demonstrations.
       INTEGER VAL(LOTS)	!The integers of the list.
       INTEGER N		!Count of numbers.
       INTEGER I,I1		!Steppers.
        N = 1		!Presume there to be one number.
        DO I = 1,LEN(TEXT)	!Then by noticing commas,
          IF (TEXT(I:I).EQ.",") N = N + 1	!Determine how many more there are.
        END DO			!Step alonmg the text.
        IF (N.LE.2) RETURN	!One comma = two values. Boring.
        IF (N.GT.LOTS) STOP "Too many values!"
        READ (TEXT,*) VAL(1:N)	!Get the numbers, with free-format flexibility.
        TEXT = ""		!Scrub the parameter!
        L = 0			!No text has been placed.
        I1 = 1			!Start the scan.
   10   IF (L.GT.0) CALL EMIT(",")	!A comma if there is prior text.
        CALL SPLOT(VAL(I1))		!The first number always appears.
        DO I = I1 + 1,N			!Now probe ahead
          IF (VAL(I - 1) + 1 .NE. VAL(I)) EXIT	!While values are consecutive.
        END DO				!Up to the end of the remaining list.
        IF (I - I1 .GT. 2) THEN		!More than two consecutive values seen?
          CALL EMIT("-")		!Yes!
          CALL SPLOT(VAL(I - 1))	!The ending number of a range.
          I1 = I			!Finger the first beyond the run.
         ELSE			!But if too few to be worth a span,
          I1 = I1 + 1			!Just finger the next number.
        END IF			!So much for that starter.
        IF (I.LE.N) GO TO 10	!Any more?
       CONTAINS		!Some assistants to save on repetition.
        SUBROUTINE EMIT(C)	!Rolls forth one character.
         CHARACTER*1 C		!The character.
          L = L + 1		!Advance the finger.
          IF (L.GT.LEN(TEXT)) STOP "Ran out of text!"	!Maybe not.
          TEXT(L:L) = C		!And place the character.
        END SUBROUTINE EMIT	!That was simple.
        SUBROUTINE SPLOT(N)	!Rolls forth a signed number.
         INTEGER N		!The number.
         CHARACTER*12 FIELD	!Sufficient for 32-bit integers.
         INTEGER I		!A stepper.
          WRITE (FIELD,"(I0)") N!Roll the number, with trailing spaces.
          DO I = 1,12		!Now transfer the text of the number.
            IF (FIELD(I:I).LE." ") EXIT	!Up to the first space.
            CALL EMIT(FIELD(I:I))	!One by one.
          END DO		!On to the end.
        END SUBROUTINE SPLOT	!Not so difficult either.
      END	!So much for IRANGE.

      PROGRAM POKE
      CHARACTER*(200) SOME
      SOME = "  0,  1,  2,  4,  6,  7,  8, 11, 12, 14,  "
     1      //"  15, 16, 17, 18, 19, 20, 21, 22, 23, 24,"
     2      //"25, 27, 28, 29, 30, 31, 32, 33, 35, 36,  "
     3      //"37, 38, 39                               "
      CALL IRANGE(SOME)
      WRITE (6,*) SOME
      END
