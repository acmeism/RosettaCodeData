       IDENTIFICATION DIVISION.
       PROGRAM-ID. PERNICIOUS-NUMBERS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 AMOUNT             PIC 99.
          03 CAND               PIC 9(9).
          03 POPCOUNT           PIC 99.
          03 POP-N              PIC 9(9).
          03 FILLER             REDEFINES POP-N.
             05 FILLER          PIC 9(8).
             05 FILLER          PIC 9.
                88 ODD          VALUES 1, 3, 5, 7, 9.
          03 DSOR               PIC 99.
          03 DIV-RSLT           PIC 99V99.
          03 FILLER             REDEFINES DIV-RSLT.
             05 FILLER          PIC 99.
             05 FILLER          PIC 99.
                88 DIVISIBLE    VALUE ZERO.
          03 PRIME-FLAG         PIC X.
             88 PRIME           VALUE '*'.

       01 FORMAT.
          03 SIZE-FLAG          PIC X.
             88 SMALL           VALUE 'S'.
             88 LARGE           VALUE 'L'.
          03 SMALL-NUM          PIC ZZ9.
          03 LARGE-NUM          PIC Z(9)9.
          03 OUT-STR            PIC X(80).
          03 OUT-PTR            PIC 99.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SMALL-PERNICIOUS.
           PERFORM LARGE-PERNICIOUS.
           STOP RUN.

       INIT-OUTPUT-VARS.
           MOVE ZERO TO AMOUNT.
           MOVE 1 TO OUT-PTR.
           MOVE SPACES TO OUT-STR.

       SMALL-PERNICIOUS.
           PERFORM INIT-OUTPUT-VARS.
           MOVE 'S' TO SIZE-FLAG.
           PERFORM ADD-PERNICIOUS
               VARYING CAND FROM 1 BY 1 UNTIL AMOUNT IS EQUAL TO 25.
           DISPLAY OUT-STR.

       LARGE-PERNICIOUS.
           PERFORM INIT-OUTPUT-VARS.
           MOVE 'L' TO SIZE-FLAG.
           PERFORM ADD-PERNICIOUS
               VARYING CAND FROM 888888877 BY 1
               UNTIL CAND IS GREATER THAN 888888888.
           DISPLAY OUT-STR.

       ADD-NUM.
           ADD 1 TO AMOUNT.
           IF SMALL,
               MOVE CAND TO SMALL-NUM,
               STRING SMALL-NUM DELIMITED BY SIZE INTO OUT-STR
               WITH POINTER OUT-PTR.
           IF LARGE,
               MOVE CAND TO LARGE-NUM,
               STRING LARGE-NUM DELIMITED BY SIZE INTO OUT-STR
               WITH POINTER OUT-PTR.

       ADD-PERNICIOUS.
           PERFORM FIND-POPCOUNT.
           PERFORM CHECK-PRIME.
           IF PRIME, PERFORM ADD-NUM.

       FIND-POPCOUNT.
           MOVE ZERO TO POPCOUNT.
           MOVE CAND TO POP-N.
           PERFORM COUNT-BIT UNTIL POP-N IS EQUAL TO ZERO.

       COUNT-BIT.
           IF ODD, ADD 1 TO POPCOUNT.
           DIVIDE 2 INTO POP-N.

       CHECK-PRIME.
           IF POPCOUNT IS LESS THAN 2,
               MOVE SPACE TO PRIME-FLAG
           ELSE
               MOVE '*' TO PRIME-FLAG.
           PERFORM CHECK-DSOR VARYING DSOR FROM 2 BY 1
               UNTIL NOT PRIME OR DSOR IS NOT LESS THAN POPCOUNT.

       CHECK-DSOR.
           DIVIDE POPCOUNT BY DSOR GIVING DIV-RSLT.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
