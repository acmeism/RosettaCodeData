       IDENTIFICATION DIVISION.
       PROGRAM-ID. MIDDLE-SQUARE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 STATE.
          03 SEED         PIC 9(6) VALUE 675248.
          03 SQUARE       PIC 9(12).
          03 FILLER       REDEFINES SQUARE.
             05 FILLER    PIC 9(3).
             05 NEXT-SEED PIC 9(6).
             05 FILLER    PIC 9(3).

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SHOW-NUM 5 TIMES.
           STOP RUN.

       SHOW-NUM.
           PERFORM MAKE-RANDOM.
           DISPLAY SEED.

       MAKE-RANDOM.
           MULTIPLY SEED BY SEED GIVING SQUARE.
           MOVE NEXT-SEED TO SEED.
