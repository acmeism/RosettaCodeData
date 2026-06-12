       IDENTIFICATION DIVISION.
       PROGRAM-ID. MINIMUM-CELLS-N-BY-N.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TABLE-SIZE        PIC 99 VALUE 10.
       01 X                 PIC 99.
       01 Y                 PIC 99.
       01 ITEM              PIC 99.
       01 MIN               PIC 99.

       01 FMT               PIC ZZ9.
       01 TABLE-LINE        PIC X(72).
       01 LINE-PTR          PIC 99.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM MAKE-LINE VARYING Y FROM 0 BY 1
               UNTIL Y IS EQUAL TO TABLE-SIZE.
           STOP RUN.

       MAKE-LINE.
           MOVE SPACES TO TABLE-LINE.
           MOVE 1 TO LINE-PTR.
           PERFORM ADD-ITEM VARYING X FROM 0 BY 1
               UNTIL X IS EQUAL TO TABLE-SIZE.
           DISPLAY TABLE-LINE.

       ADD-ITEM.
           PERFORM FIND-MINIMUM-VALUE.
           MOVE MIN TO FMT.
           STRING FMT DELIMITED BY SIZE INTO TABLE-LINE
               WITH POINTER LINE-PTR.

       FIND-MINIMUM-VALUE.
           MOVE X TO MIN.
           MOVE Y TO ITEM.
           PERFORM CHECK-MINIMUM.
           COMPUTE ITEM = TABLE-SIZE - Y - 1.
           PERFORM CHECK-MINIMUM.
           COMPUTE ITEM = TABLE-SIZE - X - 1.
           PERFORM CHECK-MINIMUM.

       CHECK-MINIMUM.
           IF ITEM IS LESS THAN MIN, MOVE ITEM TO MIN.
