      * NB: COBOL's ACCEPT does not work with multiple identifiers
       IDENTIFICATION DIVISION.
           PROGRAM-ID. PLUS.
       DATA DIVISION.
       01 A PICTURE IS S9999.
       01 B LIKE A.
       PROCEDURE DIVISION.
           DISPLAY "Enter two numbers: " WITH NO ADVANCING.
           ACCEPT A B.
           ADD A TO B.
           DISPLAY "A+B =" B.
