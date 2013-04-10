       * FIZZBUZZ.COB
       * cobc -x -g FIZZBUZZ.COB
       *
       IDENTIFICATION        DIVISION.
       PROGRAM-ID.           fizzbuzz.
       DATA                  DIVISION.
       WORKING-STORAGE       SECTION.
       01 CNT      PIC 9(03) VALUE 1.
       01 REM      PIC 9(03) VALUE 0.
       01 QUOTIENT PIC 9(03) VALUE 0.
       PROCEDURE             DIVISION.
       *
       PERFORM UNTIL CNT > 100
         DIVIDE 15 INTO CNT GIVING QUOTIENT REMAINDER REM
         IF REM = 0
           THEN
             DISPLAY "FizzBuzz " WITH NO ADVANCING
           ELSE
             DIVIDE 3 INTO CNT GIVING QUOTIENT REMAINDER REM
             IF REM = 0
               THEN
                 DISPLAY "Fizz " WITH NO ADVANCING
               ELSE
                 DIVIDE 5 INTO CNT GIVING QUOTIENT REMAINDER REM
                 IF REM = 0
                   THEN
                     DISPLAY "Buzz " WITH NO ADVANCING
                   ELSE
                     DISPLAY CNT " " WITH NO ADVANCING
                 END-IF
             END-IF
         END-IF
         ADD 1 TO CNT
       END-PERFORM
       DISPLAY ""
       STOP RUN.
