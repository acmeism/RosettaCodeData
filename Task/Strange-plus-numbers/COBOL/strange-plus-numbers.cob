       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRANGE-PLUS-NUMBERS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 CANDIDATE            PIC 999.
          03 DIGITS               REDEFINES CANDIDATE,
                                  PIC 9 OCCURS 3 TIMES.
          03 LEFT-PAIR            PIC 99.
             88 LEFT-PAIR-PRIME   VALUES 2, 3, 5, 7, 11, 13, 17.
          03 RIGHT-PAIR           PIC 99.
             88 RIGHT-PAIR-PRIME  VALUES 2, 3, 5, 7, 11, 13, 17.
       01 OUT.
          03 ROW                  PIC X(40) VALUE SPACES.
          03 PTR                  PIC 99 VALUE 1.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CHECK-STRANGE-NUMBER
           VARYING CANDIDATE FROM 100 BY 1
           UNTIL CANDIDATE IS GREATER THAN 500.
           DISPLAY ROW.
           STOP RUN.

       CHECK-STRANGE-NUMBER.
           ADD DIGITS(1), DIGITS(2) GIVING LEFT-PAIR.
           ADD DIGITS(2), DIGITS(3) GIVING RIGHT-PAIR.
           IF LEFT-PAIR-PRIME AND RIGHT-PAIR-PRIME,
               PERFORM WRITE-STRANGE-NUMBER.

       WRITE-STRANGE-NUMBER.
           STRING CANDIDATE DELIMITED BY SIZE INTO ROW
           WITH POINTER PTR.
           ADD 1 TO PTR.
           IF PTR IS GREATER THAN 40,
               DISPLAY ROW,
               MOVE SPACES TO ROW,
               MOVE 1 TO PTR.
