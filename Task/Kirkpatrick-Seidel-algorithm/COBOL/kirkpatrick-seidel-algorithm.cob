       IDENTIFICATION DIVISION.
       PROGRAM-ID. ConvexHullAlgorithm.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  NUM-POINTS          PIC 99 VALUE 4.
       01  POINT-ARRAY.
           05  POINTS OCCURS 10 TIMES INDEXED BY PT-IDX.
               10  PX          PIC S99V99.
               10  PY          PIC S99V99.

       01  INPUT-ARRAY.
           05  INP-POINTS OCCURS 10 TIMES.
               10  INP-X          PIC S99V99.
               10  INP-Y          PIC S99V99.

       01  HULL-ARRAY.
           05  HULL OCCURS 20 TIMES INDEXED BY H-IDX.
               10  HX          PIC S99V99.
               10  HY          PIC S99V99.
       01  HULL-COUNT          PIC 99 VALUE 0.

       01  U-HULL-GRP.
           05  U-HULL OCCURS 20 TIMES.
               10  UX          PIC S99V99.
               10  UY          PIC S99V99.
       01  U-COUNT             PIC 99 VALUE 0.

       01  L-HULL-GRP.
           05  L-HULL OCCURS 20 TIMES.
               10  LX          PIC S99V99.
               10  LY          PIC S99V99.
       01  L-COUNT             PIC 99 VALUE 0.

       01  I                   PIC 99.
       01  J                   PIC 99.
       01  K                   PIC 99.
       01  TEMP-X              PIC S99V99.
       01  TEMP-Y              PIC S99V99.

       01  O-X                 PIC S99V99.
       01  O-Y                 PIC S99V99.
       01  A-X                 PIC S99V99.
       01  A-Y                 PIC S99V99.
       01  B-X                 PIC S99V99.
       01  B-Y                 PIC S99V99.
       01  CROSS-PROD          PIC S9999V9999.

       01  OUT-X               PIC -9.9.
       01  OUT-Y               PIC -9.9.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INIT-POINTS.
           PERFORM PRINT-INPUT.
           PERFORM SORT-POINTS.
           PERFORM COMPUTE-HULL.
           PERFORM PRINT-HULL.
           STOP RUN.

       INIT-POINTS.
           MOVE 0.0 TO INP-X(1) PX(1). MOVE 0.0 TO INP-Y(1) PY(1).
           MOVE 1.0 TO INP-X(2) PX(2). MOVE 0.0 TO INP-Y(2) PY(2).
           MOVE 0.0 TO INP-X(3) PX(3). MOVE 1.0 TO INP-Y(3) PY(3).
           MOVE 0.5 TO INP-X(4) PX(4). MOVE 0.5 TO INP-Y(4) PY(4).

       PRINT-INPUT.
           DISPLAY "Input points:".
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-POINTS
               MOVE INP-X(I) TO OUT-X
               MOVE INP-Y(I) TO OUT-Y
               DISPLAY "(" FUNCTION TRIM(OUT-X) ", "
                       FUNCTION TRIM(OUT-Y) ")"
           END-PERFORM.
           DISPLAY " ".

       SORT-POINTS.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-POINTS - 1
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > NUM-POINTS - I
                   COMPUTE K = J + 1
                   IF PX(J) > PX(K) OR (PX(J) = PX(K) AND PY(J) > PY(K))
                       MOVE PX(J) TO TEMP-X
                       MOVE PY(J) TO TEMP-Y
                       MOVE PX(K) TO PX(J)
                       MOVE PY(K) TO PY(J)
                       MOVE TEMP-X TO PX(K)
                       MOVE TEMP-Y TO PY(K)
                   END-IF
               END-PERFORM
           END-PERFORM.

       COMPUTE-HULL.
      *    Lower Hull
           MOVE 0 TO L-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-POINTS
               PERFORM UNTIL L-COUNT < 2
                   MOVE LX(L-COUNT - 1) TO O-X
                   MOVE LY(L-COUNT - 1) TO O-Y
                   MOVE LX(L-COUNT)     TO A-X
                   MOVE LY(L-COUNT)     TO A-Y
                   MOVE PX(I)           TO B-X
                   MOVE PY(I)           TO B-Y
                   PERFORM CALC-CROSS
                   IF CROSS-PROD <= 0
                       SUBTRACT 1 FROM L-COUNT
                   ELSE
                       EXIT PERFORM
                   END-IF
               END-PERFORM
               ADD 1 TO L-COUNT
               MOVE PX(I) TO LX(L-COUNT)
               MOVE PY(I) TO LY(L-COUNT)
           END-PERFORM.

      *    Upper Hull
           MOVE 0 TO U-COUNT.
           PERFORM VARYING I FROM NUM-POINTS BY -1 UNTIL I < 1
               PERFORM UNTIL U-COUNT < 2
                   MOVE UX(U-COUNT - 1) TO O-X
                   MOVE UY(U-COUNT - 1) TO O-Y
                   MOVE UX(U-COUNT)     TO A-X
                   MOVE UY(U-COUNT)     TO A-Y
                   MOVE PX(I)           TO B-X
                   MOVE PY(I)           TO B-Y
                   PERFORM CALC-CROSS
                   IF CROSS-PROD <= 0
                       SUBTRACT 1 FROM U-COUNT
                   ELSE
                       EXIT PERFORM
                   END-IF
               END-PERFORM
               ADD 1 TO U-COUNT
               MOVE PX(I) TO UX(U-COUNT)
               MOVE PY(I) TO UY(U-COUNT)
           END-PERFORM.

      *    Combine into HULL (Match Java Output Exact Sequence)
           MOVE 0 TO HULL-COUNT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > U-COUNT - 1
               COMPUTE K = U-COUNT - I
               ADD 1 TO HULL-COUNT
               MOVE UX(K) TO HX(HULL-COUNT)
               MOVE UY(K) TO HY(HULL-COUNT)
           END-PERFORM
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > L-COUNT - 1
               ADD 1 TO HULL-COUNT
               MOVE LX(I) TO HX(HULL-COUNT)
               MOVE LY(I) TO HY(HULL-COUNT)
           END-PERFORM.

       CALC-CROSS.
           COMPUTE CROSS-PROD =
               (A-X - O-X) * (B-Y - O-Y) -
               (A-Y - O-Y) * (B-X - O-X).

       PRINT-HULL.
           DISPLAY "Convex hull points:".
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > HULL-COUNT
               MOVE HX(I) TO OUT-X
               MOVE HY(I) TO OUT-Y
               DISPLAY "(" FUNCTION TRIM(OUT-X) ", "
                       FUNCTION TRIM(OUT-Y) ")"
           END-PERFORM.

