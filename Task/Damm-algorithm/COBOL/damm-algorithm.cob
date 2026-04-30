IDENTIFICATION DIVISION.
       PROGRAM-ID. DAMM-ALGORITHM.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Damm quasi-group table (10x10)
       01 DAMM-TABLE.
          05 ROW-0.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 2.
          05 ROW-1.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 3.
          05 ROW-2.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 9.
          05 ROW-3.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 6.
          05 ROW-4.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 8.
          05 ROW-5.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 1.
          05 ROW-6.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 4.
          05 ROW-7.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 7.
          05 ROW-8.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 0.
             10 FILLER PIC 9 VALUE 5.
          05 ROW-9.
             10 FILLER PIC 9 VALUE 2.
             10 FILLER PIC 9 VALUE 5.
             10 FILLER PIC 9 VALUE 8.
             10 FILLER PIC 9 VALUE 1.
             10 FILLER PIC 9 VALUE 4.
             10 FILLER PIC 9 VALUE 3.
             10 FILLER PIC 9 VALUE 6.
             10 FILLER PIC 9 VALUE 7.
             10 FILLER PIC 9 VALUE 9.
             10 FILLER PIC 9 VALUE 0.

      *> Redefine table as a 2D array for indexed access
       01 DAMM-TABLE-R REDEFINES DAMM-TABLE.
          05 DAMM-ROW OCCURS 10 TIMES.
             10 DAMM-CELL OCCURS 10 TIMES PIC 9.

      *> Test numbers
       01 TEST-NUMBERS.
          05 TEST-NUM PIC 9(6) VALUE 005724.
          05 TEST-NUM PIC 9(6) VALUE 005727.
          05 TEST-NUM PIC 9(6) VALUE 112946.
          05 TEST-NUM PIC 9(6) VALUE 112949.

       01 TEST-NUMBERS-R REDEFINES TEST-NUMBERS.
          05 TEST-ENTRY OCCURS 4 TIMES PIC 9(6).

      *> Working variables
       01 WS-NUMBER-STR        PIC X(6).
       01 WS-INTERIM           PIC 9 VALUE 0.
       01 WS-DIGIT             PIC 9.
       01 WS-ROW-IDX           PIC 99.
       01 WS-COL-IDX           PIC 99.
       01 WS-CHAR-POS          PIC 9.
       01 WS-STR-LEN           PIC 9.
       01 WS-LOOP-IDX          PIC 9.
       01 WS-NUM-IDX           PIC 9.
       01 WS-IS-VALID          PIC X VALUE 'N'.
       01 WS-DISPLAY-NUM       PIC Z(5)9.

       PROCEDURE DIVISION.

       MAIN-PARA.
           PERFORM VARYING WS-NUM-IDX FROM 1 BY 1
                   UNTIL WS-NUM-IDX > 4

               MOVE TEST-ENTRY(WS-NUM-IDX) TO WS-DISPLAY-NUM
               MOVE TEST-ENTRY(WS-NUM-IDX) TO WS-NUMBER-STR

      *>        Strip leading zeros to get actual digit string
               MOVE FUNCTION TRIM(WS-NUMBER-STR LEADING)
                    TO WS-NUMBER-STR
               MOVE FUNCTION LENGTH(
                    FUNCTION TRIM(WS-NUMBER-STR TRAILING))
                    TO WS-STR-LEN

               PERFORM DAMM-CHECK

               IF WS-IS-VALID = 'Y'
                   DISPLAY WS-DISPLAY-NUM " is valid"
               ELSE
                   DISPLAY WS-DISPLAY-NUM " is invalid"
               END-IF

           END-PERFORM

           STOP RUN.

       DAMM-CHECK.
           MOVE 0 TO WS-INTERIM

           PERFORM VARYING WS-CHAR-POS FROM 1 BY 1
                   UNTIL WS-CHAR-POS > WS-STR-LEN

               MOVE WS-NUMBER-STR(WS-CHAR-POS:1) TO WS-DIGIT

      *>        Table is 1-indexed in COBOL, so add 1 to row/col
               COMPUTE WS-ROW-IDX = WS-INTERIM + 1
               COMPUTE WS-COL-IDX = WS-DIGIT + 1

               MOVE DAMM-CELL(WS-ROW-IDX, WS-COL-IDX)
                    TO WS-INTERIM

           END-PERFORM

           IF WS-INTERIM = 0
               MOVE 'Y' TO WS-IS-VALID
           ELSE
               MOVE 'N' TO WS-IS-VALID
           END-IF.
