       IDENTIFICATION DIVISION.
       PROGRAM-ID.  SUM-OF-CUBES.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 STEP         PIC 99.
          03 CUBE         PIC 9(7).
          03 CUBE-SUM     PIC 9(7) VALUE 0.

       01 OUTPUT-FORMAT.
          03 OUT-LINE     PIC X(40) VALUE SPACES.
          03 OUT-PTR      PIC 99 VALUE 1.
          03 OUT-NUM      PIC Z(7)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM ADD-CUBE VARYING STEP FROM 0 BY 1
               UNTIL STEP IS EQUAL TO 50.
           STOP RUN.

       ADD-CUBE.
           COMPUTE CUBE = STEP ** 3.
           ADD CUBE TO CUBE-SUM.
           MOVE CUBE-SUM TO OUT-NUM.
           STRING OUT-NUM DELIMITED BY SIZE INTO OUT-LINE
               WITH POINTER OUT-PTR.
           IF OUT-PTR IS EQUAL TO 41,
               DISPLAY OUT-LINE,
               MOVE 1 TO OUT-PTR.
