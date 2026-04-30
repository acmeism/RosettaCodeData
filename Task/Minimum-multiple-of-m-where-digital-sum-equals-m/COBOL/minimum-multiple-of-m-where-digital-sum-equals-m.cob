       IDENTIFICATION DIVISION.
       PROGRAM-ID. A131382.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 MAXIMUM      PIC 99 VALUE 40.
          03 N            PIC 999.
          03 M            PIC 9(9).
          03 N-TIMES-M    PIC 9(9).
          03 DIGITS       PIC 9 OCCURS 9 TIMES,
                          REDEFINES N-TIMES-M,
                          INDEXED BY D.
          03 DIGITSUM     PIC 999 VALUE ZERO.
       01 OUTFMT.
          03 FILLER       PIC XX VALUE "A(".
          03 N-OUT        PIC Z9.
          03 FILLER       PIC X(4) VALUE ") = ".
          03 M-OUT        PIC Z(8)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CALC-A131382 VARYING N FROM 1 BY 1
           UNTIL N IS GREATER THAN MAXIMUM.
           STOP RUN.

       CALC-A131382.
           PERFORM FIND-LEAST-M VARYING M FROM 1 BY 1
           UNTIL DIGITSUM IS EQUAL TO N.
           SUBTRACT 1 FROM M.
           MOVE N TO N-OUT.
           MOVE M TO M-OUT.
           DISPLAY OUTFMT.

       FIND-LEAST-M.
           MOVE ZERO TO DIGITSUM.
           MULTIPLY N BY M GIVING N-TIMES-M.
           PERFORM ADD-DIGIT VARYING D FROM 1 BY 1
           UNTIL D IS GREATER THAN 9.

       ADD-DIGIT.
           ADD DIGITS(D) TO DIGITSUM.
