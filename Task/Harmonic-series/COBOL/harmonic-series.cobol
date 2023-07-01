       IDENTIFICATION DIVISION.
       PROGRAM-ID. HARMONIC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARS.
          03 N           PIC 9(5) VALUE ZERO.
          03 HN          PIC 9(2)V9(12) VALUE ZERO.
          03 INT         PIC 99 VALUE ZERO.
       01 OUT-VARS.
          03 POS         PIC Z(4)9.
          03 FILLER      PIC X(3) VALUE SPACES.
          03 H-OUT       PIC Z9.9(12).

       PROCEDURE DIVISION.
       BEGIN.
           DISPLAY "First 20 harmonic numbers:"
           PERFORM SHOW-HARMONIC 20 TIMES.
           DISPLAY SPACES.
           MOVE ZERO TO N, HN.
           DISPLAY "First harmonic number to exceed whole number:"
           PERFORM EXCEED-INT 10 TIMES.
           STOP RUN.

       SHOW-HARMONIC.
           PERFORM NEXT-HARMONIC.
           MOVE HN TO H-OUT.
           DISPLAY H-OUT.

       EXCEED-INT.
           ADD 1 TO INT.
           PERFORM NEXT-HARMONIC UNTIL HN IS GREATER THAN INT.
           MOVE N TO POS.
           MOVE HN TO H-OUT.
           DISPLAY OUT-VARS.

       NEXT-HARMONIC.
           ADD 1 TO N.
           COMPUTE HN = HN + 1 / N.
