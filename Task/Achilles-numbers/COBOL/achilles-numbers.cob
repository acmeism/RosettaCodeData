       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACHILLES-NUMBERS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CONSTANTS.
          05 MAX-LIMIT     PIC 9(10) COMP VALUE 100000000.
          05 MAX-LIMIT-SQR PIC 9(6) COMP VALUE 10000.
          05 MAX-LIMIT-CUB PIC 9(6) COMP VALUE 464.

       01 PP-TEMP-DATA.
          05 PP-TEMP-COUNT PIC 9(6) COMP VALUE 0.
          05 PP-TEMP-TABLE.
             10 PP-TEMP OCCURS 1 TO 15000 TIMES DEPENDING ON PP-TEMP-COUNT
                            ASCENDING KEY IS PP-TEMP
                            PIC 9(10) COMP.

       01 PP-FINAL-DATA.
          05 PP-COUNT      PIC 9(6) COMP VALUE 0.
          05 PP-TABLE.
             10 P-POWER    OCCURS 1 TO 15000 TIMES DEPENDING ON PP-COUNT
                            ASCENDING KEY IS P-POWER
                            INDEXED BY PP-IDX
                            PIC 9(10) COMP.

       01 ACH-TEMP-DATA.
          05 ACH-TEMP-COUNT PIC 9(6) COMP VALUE 0.
          05 ACH-TEMP-TABLE.
             10 ACH-TEMP   OCCURS 1 TO 35000 TIMES DEPENDING ON ACH-TEMP-COUNT
                            ASCENDING KEY IS ACH-TEMP
                            PIC 9(10) COMP.

       01 ACH-FINAL-DATA.
          05 ACH-COUNT     PIC 9(6) COMP VALUE 0.
          05 ACH-TABLE.
             10 ACHILLES   OCCURS 1 TO 15000 TIMES DEPENDING ON ACH-COUNT
                            ASCENDING KEY IS ACHILLES
                            INDEXED BY ACH-IDX
                            PIC 9(10) COMP.

       01 LOOP-VARS.
          05 I             PIC 9(6) COMP.
          05 B             PIC 9(6) COMP.
          05 A             PIC 9(6) COMP.
          05 LAST-VAL      PIC 9(10) COMP.

       01 CALC-VARS.
          05 P             PIC 9(18) COMP.
          05 B3            PIC 9(18) COMP.
          05 SEARCH-P      PIC 9(10) COMP.

       01 TOT-VARS.
          05 TOTIENT-IN    PIC 9(10) COMP.
          05 TOTIENT-OUT   PIC 9(10) COMP.
          05 TOT-I         PIC 9(10) COMP.
          05 TOT-N         PIC 9(10) COMP.
          05 TOT-Q         PIC 9(10) COMP.
          05 TOT-R         PIC 9(10) COMP.
          05 SUB-VAL       PIC 9(10) COMP.

       01 STRONG-ACH-VARS.
          05 FOUND-FLAG    PIC 9 VALUE 0.
          05 STRONG-COUNT  PIC 9(4) COMP VALUE 0.
          05 STRONG-ACH    OCCURS 30 TIMES PIC 9(10) COMP.

       01 REPORT-VARS.
          05 DISP-4        PIC ZZZ9.
          05 DISP-5        PIC ZZZZ9.
          05 DISP-2        PIC Z9.
          05 DISP-NUM      PIC Z(9)9.
          05 FORMATTED-LINE PIC X(60) VALUE SPACES.
          05 LINE-POS      PIC 9(4) COMP VALUE 1.
          05 ROW-COUNT     PIC 9(4) COMP VALUE 0.
          05 DIGIT-COUNT   PIC 9(10) COMP.
          05 D             PIC 9(2) COMP.
          05 LOWER-BND     PIC 9(10) COMP.
          05 UPPER-BND     PIC 9(10) COMP.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM GENERATE-PERFECT-POWERS.
           PERFORM GENERATE-ACHILLES.
           PERFORM PRINT-FIRST-50.
           PERFORM PRINT-STRONG-30.
           PERFORM PRINT-DIGITS.
           STOP RUN.

       GENERATE-PERFECT-POWERS.
           MOVE 0 TO PP-TEMP-COUNT.
           PERFORM VARYING I FROM 2 BY 1 UNTIL I > MAX-LIMIT-SQR
               COMPUTE P = I * I
               PERFORM UNTIL P >= MAX-LIMIT
                   ADD 1 TO PP-TEMP-COUNT
                   MOVE P TO PP-TEMP(PP-TEMP-COUNT)
                   COMPUTE P = P * I
               END-PERFORM
           END-PERFORM.

           SORT PP-TEMP ON ASCENDING KEY PP-TEMP.

           MOVE 0 TO PP-COUNT.
           MOVE 0 TO LAST-VAL.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > PP-TEMP-COUNT
               IF PP-TEMP(I) NOT = LAST-VAL THEN
                   ADD 1 TO PP-COUNT
                   MOVE PP-TEMP(I) TO P-POWER(PP-COUNT)
                   MOVE PP-TEMP(I) TO LAST-VAL
               END-IF
           END-PERFORM.

       GENERATE-ACHILLES.
           MOVE 0 TO ACH-TEMP-COUNT.
           PERFORM VARYING B FROM 1 BY 1 UNTIL B > MAX-LIMIT-CUB
               COMPUTE B3 = B * B * B
               PERFORM VARYING A FROM 1 BY 1 UNTIL A > MAX-LIMIT-SQR
                   COMPUTE P = B3 * A * A
                   IF P >= MAX-LIMIT THEN
                       EXIT PERFORM
                   END-IF

                   IF P > 1 THEN
                       MOVE P TO SEARCH-P
                       MOVE 0 TO FOUND-FLAG
                       SEARCH ALL P-POWER
                           AT END
                               MOVE 0 TO FOUND-FLAG
                           WHEN P-POWER(PP-IDX) = SEARCH-P
                               MOVE 1 TO FOUND-FLAG
                       END-SEARCH

                       IF FOUND-FLAG = 0 THEN
                           ADD 1 TO ACH-TEMP-COUNT
                           MOVE P TO ACH-TEMP(ACH-TEMP-COUNT)
                       END-IF
                   END-IF
               END-PERFORM
           END-PERFORM.

           SORT ACH-TEMP ON ASCENDING KEY ACH-TEMP.

           MOVE 0 TO ACH-COUNT.
           MOVE 0 TO LAST-VAL.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > ACH-TEMP-COUNT
               IF ACH-TEMP(I) NOT = LAST-VAL THEN
                   ADD 1 TO ACH-COUNT
                   MOVE ACH-TEMP(I) TO ACHILLES(ACH-COUNT)
                   MOVE ACH-TEMP(I) TO LAST-VAL
               END-IF
           END-PERFORM.

       CALC-TOTIENT.
           MOVE TOTIENT-IN TO TOT-N
           MOVE TOTIENT-IN TO TOTIENT-OUT
           MOVE 2 TO TOT-I
           PERFORM UNTIL TOT-I * TOT-I > TOT-N
               DIVIDE TOT-N BY TOT-I GIVING TOT-Q REMAINDER TOT-R
               IF TOT-R = 0 THEN
                   PERFORM UNTIL TOT-R NOT = 0
                       DIVIDE TOT-N BY TOT-I GIVING TOT-Q REMAINDER TOT-R
                       IF TOT-R = 0 THEN
                           MOVE TOT-Q TO TOT-N
                       END-IF
                   END-PERFORM
                   DIVIDE TOTIENT-OUT BY TOT-I GIVING SUB-VAL
                   SUBTRACT SUB-VAL FROM TOTIENT-OUT
               END-IF
               IF TOT-I = 2 THEN
                   MOVE 1 TO TOT-I
               END-IF
               ADD 2 TO TOT-I
           END-PERFORM.
           IF TOT-N > 1 THEN
               DIVIDE TOTIENT-OUT BY TOT-N GIVING SUB-VAL
               SUBTRACT SUB-VAL FROM TOTIENT-OUT
           END-IF.

       PRINT-FIRST-50.
           DISPLAY "First 50 Achilles numbers:".
           MOVE SPACES TO FORMATTED-LINE.
           MOVE 1 TO LINE-POS.
           MOVE 0 TO ROW-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 50
               MOVE ACHILLES(I) TO DISP-4
               STRING DISP-4 " " DELIMITED BY SIZE
                      INTO FORMATTED-LINE WITH POINTER LINE-POS
               ADD 1 TO ROW-COUNT
               IF ROW-COUNT = 10 THEN
                   DISPLAY FORMATTED-LINE(1:LINE-POS - 1)
                   MOVE SPACES TO FORMATTED-LINE
                   MOVE 1 TO LINE-POS
                   MOVE 0 TO ROW-COUNT
               END-IF
           END-PERFORM.

       PRINT-STRONG-30.
           DISPLAY " ".
           DISPLAY "First 30 strong Achilles numbers:".
           MOVE 0 TO STRONG-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL STRONG-COUNT >= 30 OR I > ACH-COUNT
               MOVE ACHILLES(I) TO TOTIENT-IN
               PERFORM CALC-TOTIENT

               MOVE TOTIENT-OUT TO SEARCH-P
               MOVE 0 TO FOUND-FLAG
               SEARCH ALL ACHILLES
                   AT END
                       MOVE 0 TO FOUND-FLAG
                   WHEN ACHILLES(ACH-IDX) = SEARCH-P
                       MOVE 1 TO FOUND-FLAG
               END-SEARCH

               IF FOUND-FLAG = 1 THEN
                   ADD 1 TO STRONG-COUNT
                   MOVE ACHILLES(I) TO STRONG-ACH(STRONG-COUNT)
               END-IF
           END-PERFORM.

           MOVE SPACES TO FORMATTED-LINE.
           MOVE 1 TO LINE-POS.
           MOVE 0 TO ROW-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 30
               MOVE STRONG-ACH(I) TO DISP-5
               STRING DISP-5 " " DELIMITED BY SIZE
                      INTO FORMATTED-LINE WITH POINTER LINE-POS
               ADD 1 TO ROW-COUNT
               IF ROW-COUNT = 10 THEN
                   DISPLAY FORMATTED-LINE(1:LINE-POS - 1)
                   MOVE SPACES TO FORMATTED-LINE
                   MOVE 1 TO LINE-POS
                   MOVE 0 TO ROW-COUNT
               END-IF
           END-PERFORM.

       PRINT-DIGITS.
           DISPLAY " ".
           DISPLAY "Number of Achilles numbers with:".
           MOVE 10 TO LOWER-BND.
           COMPUTE UPPER-BND = 100.
           PERFORM VARYING D FROM 2 BY 1 UNTIL D > 8
               MOVE 0 TO DIGIT-COUNT
               PERFORM VARYING I FROM 1 BY 1 UNTIL I > ACH-COUNT
                   IF ACHILLES(I) >= UPPER-BND THEN
                       EXIT PERFORM
                   END-IF
                   IF ACHILLES(I) >= LOWER-BND THEN
                       ADD 1 TO DIGIT-COUNT
                   END-IF
               END-PERFORM

               MOVE D TO DISP-2
               MOVE DIGIT-COUNT TO DISP-NUM

               DISPLAY DISP-2 " digits: " FUNCTION TRIM(DISP-NUM)

               MOVE UPPER-BND TO LOWER-BND
               COMPUTE UPPER-BND = UPPER-BND * 10
           END-PERFORM.
