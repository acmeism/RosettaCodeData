IDENTIFICATION DIVISION.
       PROGRAM-ID. ABUNDANT-ODD-NUMBERS.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-VARIABLES.
           05  WS-ODD-NUM              PIC 9(10).
           05  WS-TO-DIVIDE            PIC 9(10).
           05  WS-REMAINDER            PIC 9(10).
           05  WS-SUM                  PIC 9(10).
           05  WS-RESULT-COUNT         PIC 9(5) VALUE 0.
           05  WS-LIST-INDEX           PIC 9(5) VALUE 0.
           05  WS-START                PIC 9(10).
           05  WS-FINISH               PIC 9(10).
           05  WS-LIST-SIZE            PIC 9(5).
           05  WS-PRINT-ONE            PIC X VALUE 'N'.

       01  WS-DIVISOR-LIST.
           05  WS-DIVISOR OCCURS 1000 TIMES PIC 9(10).

       01  WS-DISPLAY-FIELDS.
           05  WS-DISPLAY-NUM          PIC Z(5)9.
           05  WS-DISPLAY-SUM          PIC Z(5)9.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "First 24: ".
           MOVE 1 TO WS-START.
           MOVE 100000 TO WS-FINISH.
           MOVE 25 TO WS-LIST-SIZE.
           MOVE 'N' TO WS-PRINT-ONE.
           PERFORM ABUNDANT-ODD.

           DISPLAY " ".
           DISPLAY " ".
           DISPLAY "Thousandth: ".
           MOVE 0 TO WS-RESULT-COUNT.
           MOVE 1 TO WS-START.
           MOVE 2500000 TO WS-FINISH.
           MOVE 1000 TO WS-LIST-SIZE.
           MOVE 'Y' TO WS-PRINT-ONE.
           PERFORM ABUNDANT-ODD.

           DISPLAY " ".
           DISPLAY " ".
           DISPLAY "First over 1bn:".
           MOVE 0 TO WS-RESULT-COUNT.
           MOVE 1000000001 TO WS-START.
           MOVE 2147483647 TO WS-FINISH.
           MOVE 1 TO WS-LIST-SIZE.
           MOVE 'N' TO WS-PRINT-ONE.
           PERFORM ABUNDANT-ODD.

           STOP RUN.

       ABUNDANT-ODD.
           MOVE WS-START TO WS-ODD-NUM.
           IF FUNCTION MOD(WS-ODD-NUM, 2) = 0
               ADD 1 TO WS-ODD-NUM
           END-IF.

           PERFORM UNTIL WS-ODD-NUM >= WS-FINISH
                      OR WS-RESULT-COUNT >= WS-LIST-SIZE
               MOVE 0 TO WS-LIST-INDEX
               MOVE 0 TO WS-SUM

               PERFORM VARYING WS-TO-DIVIDE FROM 1 BY 2
                   UNTIL WS-TO-DIVIDE >= WS-ODD-NUM
                   DIVIDE WS-ODD-NUM BY WS-TO-DIVIDE
                       GIVING WS-REMAINDER
                       REMAINDER WS-REMAINDER
                   END-DIVIDE

                   IF WS-REMAINDER = 0
                       ADD 1 TO WS-LIST-INDEX
                       MOVE WS-TO-DIVIDE TO WS-DIVISOR(WS-LIST-INDEX)
                       ADD WS-TO-DIVIDE TO WS-SUM
                   END-IF
               END-PERFORM

               IF WS-SUM > WS-ODD-NUM
                   ADD 1 TO WS-RESULT-COUNT
                   IF WS-PRINT-ONE = 'N'
                       MOVE WS-ODD-NUM TO WS-DISPLAY-NUM
                       MOVE WS-SUM TO WS-DISPLAY-SUM
                       DISPLAY WS-DISPLAY-NUM " <= " WS-DISPLAY-SUM
                   END-IF
               END-IF

               IF WS-PRINT-ONE = 'Y'
                   AND WS-RESULT-COUNT >= WS-LIST-SIZE
                   MOVE WS-ODD-NUM TO WS-DISPLAY-NUM
                   MOVE WS-SUM TO WS-DISPLAY-SUM
                   DISPLAY WS-DISPLAY-NUM " <= " WS-DISPLAY-SUM
               END-IF

               ADD 2 TO WS-ODD-NUM
           END-PERFORM.
