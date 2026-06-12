       IDENTIFICATION DIVISION.
       PROGRAM-ID. SQUARE-CUBE-DIGITS-PRIME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NUMBER-SEARCH-VARS.
          03 CAND             PIC 9(6).
          03 SQUARE           PIC 9(6).
          03 CUBE             PIC 9(6).

       01 SUM-DIGITS-VARS.
          03 SUM-NUM          PIC 9(6).
          03 DIGITS           PIC 9 OCCURS 6 TIMES INDEXED BY D
                              REDEFINES SUM-NUM.
          03 SUM              PIC 99.

       01 PRIME-TEST-VARS.
          03 DIVISOR          PIC 99.
          03 DIV-TEST         PIC 99V9999.
          03 FILLER           REDEFINES DIV-TEST.
             05 FILLER        PIC 99.
             05 FILLER        PIC 9999.
                88 DIVISIBLE  VALUE ZERO.
          03 PRIME-FLAG       PIC X.
             88 PRIME         VALUE '*'.

       01 OUT-FMT             PIC Z9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CHECK-NUMBER VARYING CAND FROM 1 BY 1
           UNTIL CAND IS EQUAL TO 100.
           STOP RUN.

       CHECK-NUMBER.
           MULTIPLY CAND BY CAND GIVING SQUARE.
           MULTIPLY CAND BY SQUARE GIVING CUBE.
           MOVE SQUARE TO SUM-NUM.
           PERFORM SUM-DIGITS.
           PERFORM PRIME-TEST.
           IF PRIME,
               MOVE CUBE TO SUM-NUM,
               PERFORM SUM-DIGITS,
               PERFORM PRIME-TEST,
               IF PRIME,
                   MOVE CAND TO OUT-FMT,
                   DISPLAY OUT-FMT.

       SUM-DIGITS.
           MOVE ZERO TO SUM.
           PERFORM SUM-DIGIT VARYING D FROM 1 BY 1
           UNTIL D IS GREATER THAN 6.

       SUM-DIGIT.
           ADD DIGITS(D) TO SUM.

       PRIME-TEST.
           MOVE '*' TO PRIME-FLAG.
           PERFORM CHECK-DIVISOR VARYING DIVISOR FROM 2 BY 1
           UNTIL NOT PRIME, OR DIVISOR IS EQUAL TO SUM.

       CHECK-DIVISOR.
           DIVIDE SUM BY DIVISOR GIVING DIV-TEST.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
