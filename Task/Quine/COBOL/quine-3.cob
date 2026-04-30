       ID DIVISION.
       PROGRAM-ID. QUINE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       1 X PIC S9(4) COMP.
       1 A. 2 B.
       3 PIC X(40) VALUE "       ID DIVISION.                     ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       PROGRAM-ID. QUINE.               ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       DATA DIVISION.                   ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       WORKING-STORAGE SECTION.         ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       1 X PIC S9(4) COMP.              ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       1 A. 2 B.                        ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       2 T REDEFINES B. 3 TE OCCURS 16. ".
       3 PIC X(40) VALUE "4 T1 PIC X(40). 4 T2 PIC X(40).         ".
       3 PIC X(40) VALUE "       1 F. 2 PIC X(25)           VALUE ".
       3 PIC X(40) VALUE "'       3 PIC X(40) VALUE '.            ".
       3 PIC X(40) VALUE "       2 PIC X VALUE QUOTE. 2 FF PIC X(4".
       3 PIC X(40) VALUE "0). 2 PIC X VALUE QUOTE.                ".
       3 PIC X(40) VALUE "       2 PIC X VALUE '.'.               ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "       PROCEDURE DIVISION.              ".
       3 PIC X(40) VALUE "                                        ".
       3 PIC X(40) VALUE "           PERFORM VARYING X FROM 1 BY 1".
       3 PIC X(40) VALUE " UNTIL X > 6 DISPLAY TE (X)             ".
       3 PIC X(40) VALUE "           END-PERFORM PERFORM VARYING X".
       3 PIC X(40) VALUE " FROM 1 BY 1 UNTIL X > 16               ".
       3 PIC X(40) VALUE "           MOVE T1 (X) TO FF DISPLAY F M".
       3 PIC X(40) VALUE "OVE T2 (X) TO FF DISPLAY F              ".
       3 PIC X(40) VALUE "           END-PERFORM PERFORM VARYING X".
       3 PIC X(40) VALUE " FROM 7 BY 1 UNTIL X > 16               ".
       3 PIC X(40) VALUE "           DISPLAY TE (X) END-PERFORM ST".
       3 PIC X(40) VALUE "OP RUN.                                 ".
       2 T REDEFINES B. 3 TE OCCURS 16. 4 T1 PIC X(40). 4 T2 PIC X(40).
       1 F. 2 PIC X(25)           VALUE '       3 PIC X(40) VALUE '.
       2 PIC X VALUE QUOTE. 2 FF PIC X(40). 2 PIC X VALUE QUOTE.
       2 PIC X VALUE '.'.
       PROCEDURE DIVISION.
           PERFORM VARYING X FROM 1 BY 1 UNTIL X > 6 DISPLAY TE (X)
           END-PERFORM PERFORM VARYING X FROM 1 BY 1 UNTIL X > 16
           MOVE T1 (X) TO FF DISPLAY F MOVE T2 (X) TO FF DISPLAY F
           END-PERFORM PERFORM VARYING X FROM 7 BY 1 UNTIL X > 16
           DISPLAY TE (X) END-PERFORM STOP RUN.
