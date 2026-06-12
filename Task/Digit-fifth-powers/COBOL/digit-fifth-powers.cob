       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIGIT-FIFTH-POWER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 CANDIDATE          PIC 9(6).
          03 MAXIMUM            PIC 9(6).
          03 DIGITS             PIC 9 OCCURS 6 TIMES,
                                REDEFINES CANDIDATE.
          03 DIGIT              PIC 9.
          03 POWER-SUM          PIC 9(6).
          03 TOTAL              PIC 9(6).

       01 OUT-FORMAT.
          03 OUT-NUM            PIC Z(5)9.

       PROCEDURE DIVISION.
       BEGIN.
           MOVE ZERO TO TOTAL.
           COMPUTE MAXIMUM = 9 ** 5 * 6.
           PERFORM TEST-NUMBER
               VARYING CANDIDATE FROM 2 BY 1
               UNTIL CANDIDATE IS GREATER THAN MAXIMUM.
           DISPLAY '------ +'.
           DISPLAY TOTAL.
           STOP RUN.

       TEST-NUMBER.
           MOVE ZERO TO POWER-SUM.
           PERFORM ADD-DIGIT-POWER
               VARYING DIGIT FROM 1 BY 1
               UNTIL DIGIT IS GREATER THAN 6.
           IF POWER-SUM IS EQUAL TO CANDIDATE,
               MOVE CANDIDATE TO OUT-NUM,
               DISPLAY OUT-NUM,
               ADD CANDIDATE TO TOTAL.

       ADD-DIGIT-POWER.
           COMPUTE POWER-SUM = POWER-SUM + DIGITS(DIGIT) ** 5.
