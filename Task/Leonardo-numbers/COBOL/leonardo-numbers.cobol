       IDENTIFICATION DIVISION.
       PROGRAM-ID. Leonardo_numbers.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 LIMITE         PIC 99 VALUE 25.
       01 L0             PIC 99(5).
       01 L1             PIC 99(5).
       01 SUMA           PIC 99(5).
       01 TMP            PIC 99(5).
       01 I              PIC 99.
       01 TEXTO          PIC X(9).

       PROCEDURE DIVISION.
           MOVE 1 TO L0
           MOVE 1 TO L1
           MOVE 1 TO SUMA
           MOVE "Leonardo" TO TEXTO
           PERFORM DISPLAY-NUMBERS

           MOVE 0 TO L0
           MOVE 1 TO L1
           MOVE 0 TO SUMA
           MOVE "Fibonacci" TO TEXTO
           PERFORM DISPLAY-NUMBERS

           STOP RUN.

       DISPLAY-NUMBERS.
           DISPLAY "Numeros de " TEXTO " (" L0 "," L1 "," SUMA "):"
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LIMITE
               IF I = 1 THEN
                   DISPLAY " " L0 WITH NO ADVANCING
               ELSE IF I = 2 THEN
                   DISPLAY " " L1 WITH NO ADVANCING
               ELSE
                   COMPUTE TMP = L0 + L1 + SUMA
                   DISPLAY " " TMP WITH NO ADVANCING
                   MOVE L0 TO TMP
                   MOVE L1 TO L0
                   ADD TMP TO L1 GIVING L1
                   ADD SUMA TO L1
               END-IF
           END-PERFORM
           DISPLAY " "
           .
