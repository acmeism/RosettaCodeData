       IDENTIFICATION DIVISION.
       PROGRAM-ID. CullenWoodallNumbers.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 n   PIC 9(4) COMP-5 VALUE 1.
       01 num PIC 9(8) COMP-5.
       01 i   PIC 9(4) COMP-5 VALUE 1.

       PROCEDURE DIVISION.
       DISPLAY "First 20 Cullen numbers:".

       PERFORM VARYING i FROM 1 BY 1 UNTIL i > 20
           COMPUTE num = i * (2 ** i) + 1
           DISPLAY num WITH NO ADVANCING
           DISPLAY " " WITH NO ADVANCING
       END-PERFORM.

       DISPLAY " ".

       DISPLAY "First 20 Woodall numbers:".

       PERFORM VARYING i FROM 1 BY 1 UNTIL i > 20
           COMPUTE num = i * (2 ** i) - 1
           DISPLAY num WITH NO ADVANCING
           DISPLAY " " WITH NO ADVANCING
       END-PERFORM.

       STOP RUN.
