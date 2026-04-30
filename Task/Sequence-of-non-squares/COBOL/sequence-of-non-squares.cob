       IDENTIFICATION DIVISION.
       PROGRAM-ID. NONSQR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NEWTON.
          03 SQR-INP           PIC 9(7)V9(5).
          03 SQUARE-ROOT       PIC 9(7)V9(5).
          03 FILLER            REDEFINES SQUARE-ROOT.
             05 FILLER         PIC 9(7).
             05 FILLER         PIC 9(5).
                88 SQUARE      VALUE ZERO.
          03 SQR-TEMP          PIC 9(7)V9(5).
       01 SEQUENCE-VARS.
          03 N                 PIC 9(7).
          03 SEQ               PIC 9(7).
       01 SMALL-FMT.
          03 N-O               PIC Z9.
          03 FILLER            PIC XX VALUE ": ".
          03 SEQ-O             PIC Z9.

       PROCEDURE DIVISION.
       BEGIN.
           DISPLAY "Sequence of non-squares from 1 to 22:"
           PERFORM SMALL-NUMS VARYING N FROM 1 BY 1
               UNTIL N IS GREATER THAN 22.

           DISPLAY SPACES.
           DISPLAY "Checking items up to 1 million..."
           PERFORM CHECK-NONSQUARE VARYING N FROM 1 BY 1
               UNTIL SQUARE OR N IS GREATER THAN 1000000.

           IF SQUARE, DISPLAY "Square found at N = " N,
           ELSE, DISPLAY "No squares found up to 1 million.".
           STOP RUN.

       SMALL-NUMS.
           PERFORM NONSQUARE.
           MOVE N TO N-O.
           MOVE SEQ TO SEQ-O.
           DISPLAY SMALL-FMT.

       CHECK-NONSQUARE.
           PERFORM NONSQUARE.
           MOVE SEQ TO SQR-INP.
           PERFORM SQRT.

       NONSQUARE.
           MOVE N TO SQR-INP.
           PERFORM SQRT.
           ADD 0.5, SQUARE-ROOT GIVING SEQ.
           ADD N TO SEQ.

       SQRT.
           MOVE SQR-INP TO SQUARE-ROOT.
           COMPUTE SQR-TEMP =
               (SQUARE-ROOT + SQR-INP / SQUARE-ROOT) / 2.
           PERFORM SQRT-LOOP UNTIL SQUARE-ROOT IS EQUAL TO SQR-TEMP.
       SQRT-LOOP.
           MOVE SQR-TEMP TO SQUARE-ROOT.
           COMPUTE SQR-TEMP =
               (SQUARE-ROOT + SQR-INP / SQUARE-ROOT) / 2.
