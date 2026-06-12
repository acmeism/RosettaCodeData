       IDENTIFICATION DIVISION.
       PROGRAM-ID. ONES-THREE-SQUARED.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 N                  PIC 9.
          03 ONES-3             PIC 9(9).
          03 SQUARE             PIC 9(15).
       01 FMT.
          03 FMT-ONES-3         PIC Z(7)9.
          03 FILLER             PIC X(5) VALUE "^2 = ".
          03 FMT-SQUARE         PIC Z(14)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM N-ONES-3 VARYING N FROM 0 BY 1 UNTIL N IS EQUAL TO 8.
           STOP RUN.

       N-ONES-3.
           MOVE ZERO TO ONES-3.
           PERFORM ADD-ONE N TIMES.
           MULTIPLY 10 BY ONES-3.
           ADD 3 TO ONES-3.
           MULTIPLY ONES-3 BY ONES-3 GIVING SQUARE.
           MOVE ONES-3 TO FMT-ONES-3.
           MOVE SQUARE TO FMT-SQUARE.
           DISPLAY FMT.

       ADD-ONE.
           MULTIPLY 10 BY ONES-3.
           ADD 1 TO ONES-3.
