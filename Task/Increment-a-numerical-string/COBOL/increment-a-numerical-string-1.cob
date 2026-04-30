       PROGRAM-ID. increment-num-str.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  str                    PIC X(5) VALUE "12345".
       01  num                    REDEFINES str PIC 9(5).

       PROCEDURE DIVISION.
           DISPLAY str
           ADD 1 TO num
           DISPLAY str

           GOBACK
           .
