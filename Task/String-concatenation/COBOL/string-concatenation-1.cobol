       IDENTIFICATION DIVISION.
       PROGRAM-ID. Concat.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Str  PIC X(7) VALUE "Hello, ".
       01  Str2 PIC X(15).

       PROCEDURE DIVISION.
           DISPLAY "Str  : " Str
           STRING Str " World!" DELIMITED BY SIZE INTO Str2
           DISPLAY "Str2 : " Str2

           GOBACK
           .
