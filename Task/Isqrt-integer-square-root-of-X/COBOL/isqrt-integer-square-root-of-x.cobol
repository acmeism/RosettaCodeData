       IDENTIFICATION DIVISION.
       PROGRAM-ID. I-SQRT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 QUAD-RET-VARS.
          03 X          PIC 9(18).
          03 Q          PIC 9(18).
          03 Z          PIC 9(18).
          03 T          PIC S9(18).
          03 R          PIC 9(18).

       01 TO-65-VARS.
          03 ISQRT-N    PIC 99.
          03 DISP-LN    PIC X(22) VALUE SPACES.
          03 DISP-FMT   PIC Z9.
          03 PTR        PIC 99 VALUE 1.

       01 BIG-SQRT-VARS.
          03 POW-7      PIC 9(18) VALUE 7.
          03 POW-N      PIC 99 VALUE 1.
          03 POW-N-OUT  PIC Z9.
          03 POW-7-OUT  PIC Z(10).

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SQRTS-TO-65.
           PERFORM BIG-SQRTS.
           STOP RUN.

       SQRTS-TO-65.
           PERFORM DISP-SMALL-SQRT
           VARYING ISQRT-N FROM 0 BY 1
           UNTIL ISQRT-N IS GREATER THAN 65.

       DISP-SMALL-SQRT.
           MOVE ISQRT-N TO X.
           PERFORM ISQRT.
           MOVE R TO DISP-FMT.
           STRING DISP-FMT DELIMITED BY SIZE INTO DISP-LN
           WITH POINTER PTR.
           IF PTR IS GREATER THAN 22,
               DISPLAY DISP-LN,
               MOVE 1 TO PTR.

       BIG-SQRTS.
           PERFORM BIG-SQRT 10 TIMES.

       BIG-SQRT.
           MOVE POW-7 TO X.
           PERFORM ISQRT.
           MOVE POW-N TO POW-N-OUT.
           MOVE R TO POW-7-OUT.
           DISPLAY "ISQRT(7^" POW-N-OUT ") = " POW-7-OUT.
           ADD 2 TO POW-N.
           MULTIPLY 49 BY POW-7.

       ISQRT.
           MOVE 1 TO Q.
           PERFORM MUL-Q-BY-4 UNTIL Q IS GREATER THAN X.
           MOVE X TO Z.
           MOVE ZERO TO R.
           PERFORM ISQRT-STEP UNTIL Q IS NOT GREATER THAN 1.

       MUL-Q-BY-4.
           MULTIPLY 4 BY Q.

       ISQRT-STEP.
           DIVIDE 4 INTO Q.
           COMPUTE T = Z - R - Q.
           DIVIDE 2 INTO R.
           IF T IS NOT LESS THAN ZERO,
               MOVE T TO Z,
               ADD Q TO R.
