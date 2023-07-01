       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUM35.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  THREE-COUNTER   USAGE BINARY-CHAR value 1.
           88 IS-THREE VALUE 3.
       01  FIVE-COUNTER    USAGE BINARY-CHAR value 1.
           88 IS-FIVE VALUE 5.
       01  SUMMER          USAGE BINARY-DOUBLE value zero.
       01  I               USAGE BINARY-LONG.
       01  N               USAGE BINARY-LONG.

       PROCEDURE DIVISION.
       10-MAIN-PROCEDURE.
           MOVE 1000000000 TO N.
           MOVE 1 TO I.
           PERFORM 20-INNER-LOOP WITH TEST AFTER UNTIL I >= N.
           DISPLAY SUMMER.
           STOP RUN.
       20-INNER-LOOP.
           IF IS-THREE OR IS-FIVE
               ADD I TO SUMMER END-ADD
               IF IS-THREE
                   MOVE 1 TO THREE-COUNTER
               ELSE
                   ADD 1 TO THREE-COUNTER
               END-IF
               IF IS-FIVE
                   MOVE 1 TO FIVE-COUNTER
               ELSE
                   ADD 1 TO FIVE-COUNTER
               END-IF
           ELSE
               ADD 1 TO FIVE-COUNTER END-ADD
               ADD 1 TO THREE-COUNTER END-ADD
           END-IF.
           ADD 1 TO I.
           EXIT.
       END PROGRAM SUM35.
