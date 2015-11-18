       IDENTIFICATION DIVISION.
       PROGRAM-ID.  FIZZBUZZ.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  X PIC 999.
       01  Y PIC 999.
       01  REM3 PIC 999.
       01  REM5 PIC 999.
       PROCEDURE DIVISION.
           PERFORM VARYING X FROM 1 BY 1 UNTIL X > 100
               DIVIDE X BY 3 GIVING Y REMAINDER REM3
               DIVIDE X BY 5 GIVING Y REMAINDER REM5
            EVALUATE REM3 ALSO REM5
              WHEN ZERO ALSO ZERO
                DISPLAY "FizzBuzz"
              WHEN ZERO ALSO ANY
                DISPLAY "Fizz"
              WHEN ANY ALSO ZERO
                DISPLAY "Buzz"
              WHEN OTHER
                DISPLAY X
            END-EVALUATE
           END-PERFORM
           STOP RUN
           .
