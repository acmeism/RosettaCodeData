       PROGRAM-ID. increment-num-str.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  num-str                PIC 9(5) VALUE 12345.

       PROCEDURE DIVISION.
           DISPLAY num-str
           ADD 1 TO num-str
           DISPLAY num-str

           GOBACK
           .
