IDENTIFICATION DIVISION.
       PROGRAM-ID. ARITHMETIC-NUMBERS.
       AUTHOR. CONVERTED-FROM-JAVA.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  COUNTERS.
           05  ARITHMETIC-COUNT        PIC 9(7) VALUE 0.
           05  COMPOSITE-COUNT         PIC 9(7) VALUE 0.
           05  N                       PIC 9(7) VALUE 1.
           05  LINE-COUNT              PIC 99 VALUE 0.

       01  FACTOR-RELATED.
           05  FACTOR-COUNT            PIC 9(4) VALUE 0.
           05  FACTOR-SUM              PIC 9(9) VALUE 0.
           05  I                       PIC 9(7).
           05  J                       PIC 9(7).
           05  PRODUCT                 PIC 9(9).
           05  DIV-REMAINDER           PIC 9(9).
           05  MOD-RESULT              PIC 9(9).
           05  TEMP-FACTOR             PIC 9(7).
           05  FOUND-FLAG              PIC X VALUE 'N'.

       01  FACTOR-TABLE.
           05  FACTORS OCCURS 1000 TIMES INDEXED BY FX.
               10  FACTOR-VALUE        PIC 9(7) VALUE 0.

       01  OUTPUT-FIELDS.
           05  N-FORMATTED             PIC ZZZ.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM UNTIL ARITHMETIC-COUNT > 1000000
               PERFORM FIND-FACTORS
               PERFORM CALCULATE-SUM
               DIVIDE FACTOR-SUM BY FACTOR-COUNT
                   GIVING MOD-RESULT REMAINDER DIV-REMAINDER

               IF DIV-REMAINDER = 0
                   ADD 1 TO ARITHMETIC-COUNT

                   IF FACTOR-COUNT > 2
                       ADD 1 TO COMPOSITE-COUNT
                   END-IF

                   IF ARITHMETIC-COUNT <= 100
                       PERFORM DISPLAY-NUMBER
                   END-IF

                   EVALUATE ARITHMETIC-COUNT
                       WHEN 1000
                       WHEN 10000
                       WHEN 100000
                       WHEN 1000000
                           PERFORM DISPLAY-MILESTONE
                   END-EVALUATE
               END-IF

               ADD 1 TO N
           END-PERFORM

           STOP RUN.

       FIND-FACTORS.
           INITIALIZE FACTOR-TABLE
           MOVE 0 TO FACTOR-COUNT

           MOVE 1 TO TEMP-FACTOR
           PERFORM ADD-UNIQUE-FACTOR

           MOVE N TO TEMP-FACTOR
           PERFORM ADD-UNIQUE-FACTOR

           MOVE 2 TO I
           PERFORM UNTIL I * I > N
               DIVIDE N BY I GIVING J REMAINDER DIV-REMAINDER

               IF DIV-REMAINDER = 0
                   MOVE I TO TEMP-FACTOR
                   PERFORM ADD-UNIQUE-FACTOR

                   MOVE J TO TEMP-FACTOR
                   PERFORM ADD-UNIQUE-FACTOR
               END-IF

               ADD 1 TO I
           END-PERFORM.

       ADD-UNIQUE-FACTOR.
           MOVE 'N' TO FOUND-FLAG
           PERFORM VARYING FX FROM 1 BY 1 UNTIL FX > FACTOR-COUNT
               IF FACTOR-VALUE(FX) = TEMP-FACTOR
                   MOVE 'Y' TO FOUND-FLAG
                   EXIT PERFORM
               END-IF
           END-PERFORM

           IF FOUND-FLAG = 'N'
               ADD 1 TO FACTOR-COUNT
               MOVE TEMP-FACTOR TO FACTOR-VALUE(FACTOR-COUNT)
           END-IF.

       CALCULATE-SUM.
           MOVE 0 TO FACTOR-SUM
           PERFORM VARYING FX FROM 1 BY 1 UNTIL FX > FACTOR-COUNT
               ADD FACTOR-VALUE(FX) TO FACTOR-SUM
           END-PERFORM.

       DISPLAY-NUMBER.
           MOVE N TO N-FORMATTED
           DISPLAY N-FORMATTED WITH NO ADVANCING
           ADD 1 TO LINE-COUNT

           IF LINE-COUNT = 10
               DISPLAY " "
               MOVE 0 TO LINE-COUNT
           ELSE
               DISPLAY " " WITH NO ADVANCING
           END-IF.

       DISPLAY-MILESTONE.
           DISPLAY " "
           DISPLAY ARITHMETIC-COUNT "th arithmetic number is " N
           DISPLAY "Number of composite arithmetic numbers <= "
               N ": " COMPOSITE-COUNT.
