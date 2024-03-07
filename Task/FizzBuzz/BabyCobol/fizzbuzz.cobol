      * NB: ANY does not exist in BabyCobol so the elegant
      * EVALUATE-based COBOL-style solution is impossible here.
      * Note the subtly unbalanced IF/ENDs yet valid END at the end.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIZZBUZZ.
       DATA DIVISION.
       01 INT PICTURE IS 9(3).
       01 REM LIKE INT.
       01 TMP LIKE INT.
       PROCEDURE DIVISION.
           LOOP VARYING INT TO 100
               DIVIDE 3 INTO INT GIVING TMP REMAINDER REM
               IF REM = 0
               THEN DISPLAY "Fizz" WITH NO ADVANCING
               DIVIDE 5 INTO INT GIVING TMP REMAINDER REM
               IF REM = 0
               THEN DISPLAY "Buzz" WITH NO ADVANCING
               DIVIDE 15 INTO INT GIVING TMP REMAINDER REM
               IF REM = 0
               THEN DISPLAY ""
               ELSE DISPLAY INT
           END.
