       IDENTIFICATION DIVISION.
       PROGRAM-ID.  MERTENS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 M             PIC S99 OCCURS 1000 TIMES.
          03 N             PIC 9(4).
          03 K             PIC 9(4).
          03 V             PIC 9(4).
          03 IS-ZERO       PIC 99 VALUE 0.
          03 CROSS-ZERO    PIC 99 VALUE 0.

       01 OUTPUT-FORMAT.
          03 OUT-ITEM.
             05 OUT-NUM    PIC -9.
             05 FILLER     PIC X VALUE SPACE.
          03 OUT-LINE      PIC X(30) VALUE SPACES.
          03 OUT-PTR       PIC 99 VALUE 4.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM GENERATE-MERTENS.
           PERFORM WRITE-TABLE.
           PERFORM COUNT-ZEROES.
           STOP RUN.

       GENERATE-MERTENS.
           MOVE 1 TO M(1).
           PERFORM MERTENS-OUTER-LOOP VARYING N FROM 2 BY 1
               UNTIL N IS GREATER THAN 1000.

       MERTENS-OUTER-LOOP.
           MOVE 1 TO M(N).
           PERFORM MERTENS-INNER-LOOP VARYING K FROM 2 BY 1
               UNTIL K IS GREATER THAN N.

       MERTENS-INNER-LOOP.
           DIVIDE N BY K GIVING V.
           SUBTRACT M(V) FROM M(N).

       WRITE-TABLE.
           DISPLAY "The first 99 Mertens numbers are: "
           PERFORM WRITE-ITEM VARYING N FROM 1 BY 1
               UNTIL N IS GREATER THAN 99.

       WRITE-ITEM.
           MOVE M(N) TO OUT-NUM.
           STRING OUT-ITEM DELIMITED BY SIZE INTO OUT-LINE
               WITH POINTER OUT-PTR.
           IF OUT-PTR IS EQUAL TO 31,
               DISPLAY OUT-LINE,
               MOVE 1 TO OUT-PTR.

       COUNT-ZEROES.
           PERFORM TEST-N-ZERO VARYING N FROM 2 BY 1
               UNTIL N IS GREATER THAN 1000.
           DISPLAY "M(N) is zero " IS-ZERO " times.".
           DISPLAY "M(N) crosses zero " CROSS-ZERO " times.".

       TEST-N-ZERO.
           IF M(N) IS EQUAL TO ZERO,
               ADD 1 TO IS-ZERO,
               SUBTRACT 1 FROM N GIVING K,
               IF M(K) IS NOT EQUAL TO ZERO,
                   ADD 1 TO CROSS-ZERO.
