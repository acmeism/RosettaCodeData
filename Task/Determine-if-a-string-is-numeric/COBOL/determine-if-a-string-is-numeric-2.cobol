       IDENTIFICATION DIVISION.
       PROGRAM-ID. Is-Numeric.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Numeric-Chars      PIC X(10) VALUE "0123456789".

       01  Success            CONSTANT 0.
       01  Failure            CONSTANT 128.

       LOCAL-STORAGE SECTION.
       01  I                  PIC 99.

       01  Num-Decimal-Points PIC 99.
       01  Num-Valid-Chars    PIC 99.

       LINKAGE SECTION.
       01  Str                PIC X(30).

       PROCEDURE DIVISION USING Str.
           IF Str = SPACES
               MOVE Failure TO Return-Code
               GOBACK
           END-IF

           MOVE FUNCTION TRIM(Str) TO Str

           INSPECT Str TALLYING Num-Decimal-Points FOR ALL "."
           IF Num-Decimal-Points > 1
               MOVE Failure TO Return-Code
               GOBACK
           ELSE
               ADD Num-Decimal-Points TO Num-Valid-Chars
           END-IF

           IF Str (1:1) = "-" OR "+"
               ADD 1 TO Num-Valid-Chars
           END-IF

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               INSPECT Str TALLYING Num-Valid-Chars
                   FOR ALL Numeric-Chars (I:1) BEFORE SPACE
           END-PERFORM

           INSPECT Str TALLYING Num-Valid-Chars FOR TRAILING SPACES

           IF Num-Valid-Chars = FUNCTION LENGTH(Str)
               MOVE Success TO Return-Code
           ELSE
               MOVE Failure TO Return-Code
           END-IF

           GOBACK
           .
