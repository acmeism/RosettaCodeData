       IDENTIFICATION DIVISION.
       PROGRAM-ID. CANTOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 SETTINGS.
          03 NUM-LINES     PIC 9 VALUE 5.
          03 FILL-CHAR     PIC X VALUE '#'.
       01 VARIABLES.
          03 CUR-LINE.
             05 CHAR       PIC X OCCURS 81 TIMES.
          03 WIDTH         PIC 99.
          03 CUR-SIZE      PIC 99.
          03 POS           PIC 99.
          03 MAXPOS        PIC 99.
          03 NEXTPOS       PIC 99.
          03 I             PIC 99.

       PROCEDURE DIVISION.
       BEGIN.
           COMPUTE WIDTH = 3 ** (NUM-LINES - 1).
           PERFORM INIT.
           MOVE WIDTH TO CUR-SIZE.
           DISPLAY CUR-LINE.
           PERFORM DO-LINE UNTIL CUR-SIZE IS EQUAL TO 1.
           STOP RUN.

       INIT.
           PERFORM INIT-CHAR VARYING I FROM 1 BY 1
                UNTIL I IS GREATER THAN WIDTH.

       INIT-CHAR.
           MOVE FILL-CHAR TO CHAR(I).

       DO-LINE.
           DIVIDE 3 INTO CUR-SIZE.
           MOVE 1 TO POS.
           SUBTRACT CUR-SIZE FROM WIDTH GIVING MAXPOS.
           PERFORM BLANK-REGIONS UNTIL POS IS GREATER THAN MAXPOS.
           DISPLAY CUR-LINE.

       BLANK-REGIONS.
           ADD CUR-SIZE TO POS.
           PERFORM BLANK-CHAR CUR-SIZE TIMES.

       BLANK-CHAR.
           MOVE SPACE TO CHAR(POS).
           ADD 1 TO POS.
