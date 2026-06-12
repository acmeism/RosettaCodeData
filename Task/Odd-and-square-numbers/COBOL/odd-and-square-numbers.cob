       IDENTIFICATION DIVISION.
       PROGRAM-ID. ODD-AND-SQUARE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 N              PIC 999.
          03 SQR            PIC 9999 VALUE 0.
          03 FILLER         REDEFINES SQR.
             05 FILLER      PIC 999.
             05 FILLER      PIC 9.
                88 ODD      VALUE 1, 3, 5, 7, 9.
          03 FMT            PIC ZZ9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CHECK VARYING N FROM 10 BY 1
                UNTIL SQR IS NOT LESS THAN 1000.
           STOP RUN.

       CHECK.
           MULTIPLY N BY N GIVING SQR.
           IF ODD, MOVE SQR TO FMT, DISPLAY FMT.
