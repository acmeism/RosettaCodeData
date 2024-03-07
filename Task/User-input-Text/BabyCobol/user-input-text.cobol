      * NB: whitespace insignificance and case insensitivity
      * are used in the field name.
       IDENTIFICATION DIVISION.
           PROGRAM-ID. USER INPUT.
       DATA DIVISION.
       01 HUNDRED CHAR STRING PICTURE IS X(100).
       01 FIVE DIGIT NUMBER PICTURE IS 9(5).
       PROCEDURE DIVISION.
           DISPLAY "Enter a string of appropriate length: " WITH NO ADVANCING
           ACCEPT HundredChar String.
           DISPLAY "Enter a number (preferably 75000): " WITH NO ADVANCING
           ACCEPT FiveDigit Number.
