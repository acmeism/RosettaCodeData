IDENTIFICATION DIVISION.
       PROGRAM-ID. COLORFUL-NUMBERS.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  COUNTERS.
           05  COUNT-ARRAY         OCCURS 8 TIMES PIC 9(8) VALUE 0.
           05  USED-ARRAY          OCCURS 10 TIMES PIC 9 VALUE 0.
           05  LARGEST             PIC 9(8) VALUE 0.

       01  LOOP-COUNTERS.
           05  N                   PIC 9(8).
           05  COUNT-NUM           PIC 9(4) VALUE 0.
           05  D                   PIC 9(2).
           05  TOTAL               PIC 9(8) VALUE 0.
           05  I                   PIC 9(2).
           05  J                   PIC 9(2).
           05  K                   PIC 9(2).

       01  COLORFUL-CHECK.
           05  DIGIT-COUNT-ARRAY   OCCURS 10 TIMES PIC 9(2).
           05  DIGITS-ARRAY        OCCURS 8 TIMES PIC 9.
           05  NUM-DIGITS          PIC 9(2).
           05  M                   PIC 9(8).
           05  DIGIT-TEMP          PIC 9.
           05  PRODUCTS-ARRAY      OCCURS 36 TIMES PIC 9(8).
           05  PRODUCT-COUNT       PIC 9(3).
           05  PRODUCT-TEMP        PIC 9(8).
           05  IS-COLORFUL-FLAG    PIC 9.

       01  DISPLAY-VARS.
           05  FORMATTED-NUM       PIC ZZ,ZZZ,ZZ9.
           05  DISPLAY-NUM         PIC Z9.

       01  STACK-STORAGE.
           05  STACK-LEVEL         PIC 9(3) VALUE 0.
           05  STACK-ENTRY         OCCURS 100 TIMES.
               10  STK-TAKEN       PIC 9(2).
               10  STK-N           PIC 9(8).
               10  STK-DIGITS      PIC 9(2).
               10  STK-D           PIC 9(2).
               10  STK-PHASE       PIC 9.
               10  STK-SAVED-USED  OCCURS 10 TIMES PIC 9.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "Colorful numbers less than 100:".
           PERFORM VARYING N FROM 0 BY 1 UNTIL N >= 100
               PERFORM CHECK-COLORFUL
               IF IS-COLORFUL-FLAG = 1
                   ADD 1 TO COUNT-NUM
                   MOVE N TO DISPLAY-NUM
                   DISPLAY DISPLAY-NUM WITH NO ADVANCING
                   IF FUNCTION MOD(COUNT-NUM, 10) = 0
                       DISPLAY " "
                   ELSE
                       DISPLAY " " WITH NO ADVANCING
                   END-IF
               END-IF
           END-PERFORM.

           DISPLAY " ".
           DISPLAY " ".

           PERFORM COUNT-ALL-COLORFUL.

           MOVE LARGEST TO FORMATTED-NUM.
           DISPLAY "Largest colorful number: " FORMATTED-NUM.
           DISPLAY " ".

           DISPLAY "Count of colorful numbers by number of digits:".
           MOVE 0 TO TOTAL.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 8
               MOVE COUNT-ARRAY(I) TO FORMATTED-NUM
               DISPLAY I "   " FORMATTED-NUM
               ADD COUNT-ARRAY(I) TO TOTAL
           END-PERFORM.

           DISPLAY " ".
           MOVE TOTAL TO FORMATTED-NUM.
           DISPLAY "Total: " FORMATTED-NUM.

           STOP RUN.

       CHECK-COLORFUL.
           MOVE 0 TO IS-COLORFUL-FLAG.

           IF N < 0 OR N > 98765432
               EXIT PARAGRAPH
           END-IF.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               MOVE 0 TO DIGIT-COUNT-ARRAY(I)
           END-PERFORM.

           MOVE 0 TO NUM-DIGITS.
           MOVE N TO M.

           PERFORM UNTIL M = 0
               COMPUTE DIGIT-TEMP = FUNCTION MOD(M, 10)

               IF N > 9 AND (DIGIT-TEMP = 0 OR DIGIT-TEMP = 1)
                   EXIT PARAGRAPH
               END-IF

               ADD 1 TO DIGIT-TEMP GIVING I
               ADD 1 TO DIGIT-COUNT-ARRAY(I)

               IF DIGIT-COUNT-ARRAY(I) > 1
                   EXIT PARAGRAPH
               END-IF

               ADD 1 TO NUM-DIGITS
               MOVE DIGIT-TEMP TO DIGITS-ARRAY(NUM-DIGITS)

               DIVIDE M BY 10 GIVING M
           END-PERFORM.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 36
               MOVE 0 TO PRODUCTS-ARRAY(I)
           END-PERFORM.

           MOVE 0 TO PRODUCT-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-DIGITS
               MOVE 1 TO PRODUCT-TEMP
               PERFORM VARYING J FROM I BY 1 UNTIL J > NUM-DIGITS
                   MULTIPLY PRODUCT-TEMP BY DIGITS-ARRAY(J)
                       GIVING PRODUCT-TEMP

                   PERFORM VARYING K FROM 1 BY 1
                           UNTIL K > PRODUCT-COUNT
                       IF PRODUCTS-ARRAY(K) = PRODUCT-TEMP
                           EXIT PARAGRAPH
                       END-IF
                   END-PERFORM

                   ADD 1 TO PRODUCT-COUNT
                   MOVE PRODUCT-TEMP TO PRODUCTS-ARRAY(PRODUCT-COUNT)
               END-PERFORM
           END-PERFORM.

           MOVE 1 TO IS-COLORFUL-FLAG.

       COUNT-ALL-COLORFUL.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               MOVE 0 TO USED-ARRAY(I)
           END-PERFORM.

           MOVE 0 TO STACK-LEVEL.
           MOVE 0 TO STK-TAKEN(1).
           MOVE 0 TO STK-N(1).
           MOVE 0 TO STK-DIGITS(1).
           MOVE 0 TO STK-D(1).
           MOVE 0 TO STK-PHASE(1).
           MOVE 1 TO STACK-LEVEL.

           PERFORM UNTIL STACK-LEVEL = 0
               PERFORM PROCESS-STACK-FRAME
           END-PERFORM.

       PROCESS-STACK-FRAME.
           IF STK-TAKEN(STACK-LEVEL) = 0
               IF STK-D(STACK-LEVEL) >= 10
                   SUBTRACT 1 FROM STACK-LEVEL
                   EXIT PARAGRAPH
               END-IF

               COMPUTE I = STK-D(STACK-LEVEL) + 1
               MOVE 1 TO USED-ARRAY(I)

               ADD 1 TO STACK-LEVEL
               IF STK-D(STACK-LEVEL - 1) < 2
                   MOVE 9 TO STK-TAKEN(STACK-LEVEL)
               ELSE
                   MOVE 1 TO STK-TAKEN(STACK-LEVEL)
               END-IF
               MOVE STK-D(STACK-LEVEL - 1) TO STK-N(STACK-LEVEL)
               MOVE 1 TO STK-DIGITS(STACK-LEVEL)
               MOVE 0 TO STK-D(STACK-LEVEL)
               MOVE 0 TO STK-PHASE(STACK-LEVEL)

               PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
                   MOVE USED-ARRAY(I) TO
                       STK-SAVED-USED(STACK-LEVEL, I)
               END-PERFORM
           ELSE
               IF STK-PHASE(STACK-LEVEL) = 0
                   MOVE STK-N(STACK-LEVEL) TO N
                   PERFORM CHECK-COLORFUL

                   IF IS-COLORFUL-FLAG = 1
                       COMPUTE I = STK-DIGITS(STACK-LEVEL)
                       ADD 1 TO COUNT-ARRAY(I)
                       IF N > LARGEST
                           MOVE N TO LARGEST
                       END-IF
                   END-IF

                   MOVE 1 TO STK-PHASE(STACK-LEVEL)
                   MOVE 2 TO STK-D(STACK-LEVEL)
               ELSE
                   IF STK-TAKEN(STACK-LEVEL) >= 9 OR
                      STK-D(STACK-LEVEL) >= 10
                       SUBTRACT 1 FROM STACK-LEVEL

                       IF STACK-LEVEL > 0
                           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
                               MOVE STK-SAVED-USED(STACK-LEVEL, I)
                                   TO USED-ARRAY(I)
                           END-PERFORM

                           COMPUTE I = STK-D(STACK-LEVEL) + 1
                           MOVE 0 TO USED-ARRAY(I)
                           ADD 1 TO STK-D(STACK-LEVEL)
                       END-IF
                       EXIT PARAGRAPH
                   END-IF

                   COMPUTE I = STK-D(STACK-LEVEL) + 1
                   IF USED-ARRAY(I) = 0
                       MOVE 1 TO USED-ARRAY(I)

                       ADD 1 TO STACK-LEVEL
                       COMPUTE STK-TAKEN(STACK-LEVEL) =
                           STK-TAKEN(STACK-LEVEL - 1) + 1
                       COMPUTE STK-N(STACK-LEVEL) =
                           STK-N(STACK-LEVEL - 1) * 10 +
                           STK-D(STACK-LEVEL - 1)
                       COMPUTE STK-DIGITS(STACK-LEVEL) =
                           STK-DIGITS(STACK-LEVEL - 1) + 1
                       MOVE 0 TO STK-D(STACK-LEVEL)
                       MOVE 0 TO STK-PHASE(STACK-LEVEL)

                       PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
                           MOVE USED-ARRAY(I) TO
                               STK-SAVED-USED(STACK-LEVEL, I)
                       END-PERFORM
                   ELSE
                       ADD 1 TO STK-D(STACK-LEVEL)
                   END-IF
               END-IF
           END-IF.
