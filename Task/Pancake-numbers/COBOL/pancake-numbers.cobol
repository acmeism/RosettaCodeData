       IDENTIFICATION DIVISION.
       PROGRAM-ID. Pancake.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 I PIC 9 VALUE 0.
       01 J PIC 9 VALUE 0.
       01 N PIC 99 VALUE 0.
       01 C PIC 99 VALUE 0.
       01 P PIC 99 VALUE 0.
       01 GAP PIC 99 VALUE 2.
       01 SUMA PIC 99 VALUE 2.
       01 ADJ PIC S99 VALUE -1.

       PROCEDURE DIVISION.
           PERFORM VARYING I FROM 0 BY 1 UNTIL I > 3
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > 5
                   COMPUTE N = (I * 5) + J
                   ADD 1 TO C
                   PERFORM PANCAKE-CALCULATION
                   DISPLAY "P(" N ") = " P
               END-PERFORM
           END-PERFORM
           STOP RUN.

       PANCAKE-CALCULATION.
           MOVE 2 TO GAP
           MOVE 2 TO SUMA
           MOVE -1 TO ADJ
           PERFORM UNTIL SUMA >= N
               ADD 1 TO ADJ
               COMPUTE GAP = (GAP * 2) - 1
               ADD GAP TO SUMA
           END-PERFORM
           COMPUTE P = N + ADJ.
