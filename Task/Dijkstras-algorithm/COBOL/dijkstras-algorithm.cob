IDENTIFICATION DIVISION.
       PROGRAM-ID. DIJKSTRA.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Maximum sizes
       01 INF-VALUE           PIC 9(6) VALUE 999999.

      *> Edge table
       01 EDGE-COUNT          PIC 99 VALUE 0.
       01 EDGE-TABLE.
          05 EDGE OCCURS 50 TIMES.
             10 EDGE-V1       PIC X(10).
             10 EDGE-V2       PIC X(10).
             10 EDGE-LEN      PIC 9(4).

      *> Vertex table
       01 VERT-COUNT          PIC 99 VALUE 0.
       01 VERT-TABLE.
          05 VERT OCCURS 20 TIMES.
             10 VERT-NAME     PIC X(10).
             10 VERT-DIST     PIC 9(6) VALUE 999999.
             10 VERT-PREV     PIC 99 VALUE 0.
             10 VERT-IN-Q     PIC X VALUE 'Y'.

      *> Adjacency matrix
       01 ADJ-MATRIX.
          05 ADJ-ROW OCCURS 20 TIMES.
             10 ADJ-COL OCCURS 20 TIMES.
                15 ADJ-WEIGHT PIC 9(4) VALUE 0.

      *> Source / Target
       01 SOURCE-NAME         PIC X(10).
       01 TARGET-NAME         PIC X(10).
       01 SOURCE-IDX          PIC 99 VALUE 0.
       01 TARGET-IDX          PIC 99 VALUE 0.

      *> Working variables
       01 I                   PIC 99 VALUE 0.
       01 J                   PIC 99 VALUE 0.
       01 U-IDX               PIC 99 VALUE 0.
       01 MIN-DIST            PIC 9(6) VALUE 999999.
       01 ALT-DIST            PIC 9(6) VALUE 0.
       01 Q-EMPTY             PIC X VALUE 'N'.
       01 FOUND               PIC X VALUE 'N'.
       01 V1-IDX              PIC 99 VALUE 0.
       01 V2-IDX              PIC 99 VALUE 0.
       01 PATH-LEN            PIC 9(6) VALUE 0.

      *> Path reconstruction
       01 PATH-COUNT          PIC 99 VALUE 0.
       01 PATH-TABLE.
          05 PATH-NODE OCCURS 20 TIMES PIC 99.
       01 PATH-IDX            PIC 99 VALUE 0.
       01 TEMP-IDX            PIC 99 VALUE 0.

      *> Temp vertex name for lookup
       01 LOOKUP-NAME         PIC X(10).
       01 LOOKUP-IDX          PIC 99 VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM BUILD-GRAPH
           PERFORM DIJKSTRA-ALGO
           PERFORM PRINT-RESULT
           STOP RUN.

      *> -------------------------------------------------------
      *> BUILD-GRAPH: Define edges and populate structures
      *> -------------------------------------------------------
       BUILD-GRAPH.
           MOVE "a"  TO SOURCE-NAME
           MOVE "e"  TO TARGET-NAME

           MOVE "a"  TO EDGE-V1(1)
           MOVE "b"  TO EDGE-V2(1)
           MOVE 7    TO EDGE-LEN(1)

           MOVE "a"  TO EDGE-V1(2)
           MOVE "c"  TO EDGE-V2(2)
           MOVE 9    TO EDGE-LEN(2)

           MOVE "a"  TO EDGE-V1(3)
           MOVE "f"  TO EDGE-V2(3)
           MOVE 14   TO EDGE-LEN(3)

           MOVE "b"  TO EDGE-V1(4)
           MOVE "c"  TO EDGE-V2(4)
           MOVE 10   TO EDGE-LEN(4)

           MOVE "b"  TO EDGE-V1(5)
           MOVE "d"  TO EDGE-V2(5)
           MOVE 15   TO EDGE-LEN(5)

           MOVE "c"  TO EDGE-V1(6)
           MOVE "d"  TO EDGE-V2(6)
           MOVE 11   TO EDGE-LEN(6)

           MOVE "c"  TO EDGE-V1(7)
           MOVE "f"  TO EDGE-V2(7)
           MOVE 2    TO EDGE-LEN(7)

           MOVE "d"  TO EDGE-V1(8)
           MOVE "e"  TO EDGE-V2(8)
           MOVE 6    TO EDGE-LEN(8)

           MOVE "e"  TO EDGE-V1(9)
           MOVE "f"  TO EDGE-V2(9)
           MOVE 9    TO EDGE-LEN(9)

           MOVE 9 TO EDGE-COUNT

      *> Register all vertices and build adjacency matrix
           PERFORM VARYING I FROM 1 BY 1
               UNTIL I > EDGE-COUNT

               MOVE EDGE-V1(I) TO LOOKUP-NAME
               PERFORM GET-OR-ADD-VERTEX
               MOVE LOOKUP-IDX TO V1-IDX

               MOVE EDGE-V2(I) TO LOOKUP-NAME
               PERFORM GET-OR-ADD-VERTEX
               MOVE LOOKUP-IDX TO V2-IDX

               MOVE EDGE-LEN(I) TO ADJ-WEIGHT(V1-IDX, V2-IDX)
               MOVE EDGE-LEN(I) TO ADJ-WEIGHT(V2-IDX, V1-IDX)
           END-PERFORM

      *> Find source and target indices
           PERFORM VARYING I FROM 1 BY 1
               UNTIL I > VERT-COUNT
               IF VERT-NAME(I) = SOURCE-NAME
                   MOVE 0 TO VERT-DIST(I)
                   MOVE I TO SOURCE-IDX
               END-IF
               IF VERT-NAME(I) = TARGET-NAME
                   MOVE I TO TARGET-IDX
               END-IF
           END-PERFORM.

      *> -------------------------------------------------------
      *> GET-OR-ADD-VERTEX
      *> Input:  LOOKUP-NAME
      *> Output: LOOKUP-IDX (existing or newly added index)
      *> -------------------------------------------------------
       GET-OR-ADD-VERTEX.
           MOVE 'N' TO FOUND
           PERFORM VARYING J FROM 1 BY 1
               UNTIL J > VERT-COUNT OR FOUND = 'Y'
               IF VERT-NAME(J) = LOOKUP-NAME
                   MOVE J   TO LOOKUP-IDX
                   MOVE 'Y' TO FOUND
               END-IF
           END-PERFORM
           IF FOUND = 'N'
               ADD 1          TO VERT-COUNT
               MOVE LOOKUP-NAME TO VERT-NAME(VERT-COUNT)
               MOVE INF-VALUE   TO VERT-DIST(VERT-COUNT)
               MOVE 0           TO VERT-PREV(VERT-COUNT)
               MOVE 'Y'         TO VERT-IN-Q(VERT-COUNT)
               MOVE VERT-COUNT  TO LOOKUP-IDX
           END-IF.

      *> -------------------------------------------------------
      *> DIJKSTRA-ALGO: Main algorithm loop
      *> -------------------------------------------------------
       DIJKSTRA-ALGO.
           MOVE 'N' TO Q-EMPTY
           PERFORM UNTIL Q-EMPTY = 'Y'

               MOVE INF-VALUE TO MIN-DIST
               MOVE 0         TO U-IDX

               PERFORM VARYING I FROM 1 BY 1
                   UNTIL I > VERT-COUNT
                   IF VERT-IN-Q(I) = 'Y' AND
                      VERT-DIST(I) < MIN-DIST
                       MOVE VERT-DIST(I) TO MIN-DIST
                       MOVE I            TO U-IDX
                   END-IF
               END-PERFORM

               IF U-IDX = 0
                   MOVE 'Y' TO Q-EMPTY
               ELSE
                   MOVE 'N' TO VERT-IN-Q(U-IDX)

                   IF U-IDX = TARGET-IDX
                       MOVE 'Y' TO Q-EMPTY
                   ELSE
                       PERFORM VARYING J FROM 1 BY 1
                           UNTIL J > VERT-COUNT
                           IF VERT-IN-Q(J) = 'Y' AND
                              ADJ-WEIGHT(U-IDX, J) > 0
                               COMPUTE ALT-DIST =
                                   VERT-DIST(U-IDX) +
                                   ADJ-WEIGHT(U-IDX, J)
                               IF ALT-DIST < VERT-DIST(J)
                                   MOVE ALT-DIST TO VERT-DIST(J)
                                   MOVE U-IDX    TO VERT-PREV(J)
                               END-IF
                           END-IF
                       END-PERFORM
                   END-IF
               END-IF
           END-PERFORM.

      *> -------------------------------------------------------
      *> PRINT-RESULT: Reconstruct and display path
      *> -------------------------------------------------------
       PRINT-RESULT.
           MOVE 0           TO PATH-COUNT
           MOVE 0           TO PATH-LEN
           MOVE TARGET-IDX  TO PATH-IDX

           PERFORM UNTIL PATH-IDX = 0
               ADD 1 TO PATH-COUNT
               MOVE PATH-IDX TO PATH-NODE(PATH-COUNT)
               MOVE VERT-PREV(PATH-IDX) TO TEMP-IDX
               IF TEMP-IDX > 0
                   ADD ADJ-WEIGHT(PATH-IDX, TEMP-IDX) TO PATH-LEN
               END-IF
               MOVE TEMP-IDX TO PATH-IDX
           END-PERFORM

           DISPLAY "Path: " WITH NO ADVANCING
           PERFORM VARYING I FROM PATH-COUNT BY -1
               UNTIL I < 1
               DISPLAY FUNCTION TRIM(VERT-NAME(PATH-NODE(I)))
                   WITH NO ADVANCING
               IF I > 1
                   DISPLAY " -> " WITH NO ADVANCING
               END-IF
           END-PERFORM
           DISPLAY " "

           DISPLAY "Length: " PATH-LEN.
