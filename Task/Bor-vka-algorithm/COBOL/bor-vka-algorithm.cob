IDENTIFICATION DIVISION.
       PROGRAM-ID. BORUVKA-MST.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *>----------------------------------------------------------------*
      *> Constants
      *>----------------------------------------------------------------*
       01  MAX-VERTICES          PIC 99 VALUE 10.
       01  MAX-EDGES             PIC 99 VALUE 50.
       01  NO-EDGE-WEIGHT        PIC S9(5)V9(2) VALUE -1.00.

      *>----------------------------------------------------------------*
      *> Graph Data
      *>----------------------------------------------------------------*
       01  VERTEX-COUNT          PIC 99 VALUE 0.
       01  EDGE-COUNT            PIC 99 VALUE 0.

       01  EDGE-TABLE.
           05  EDGE-ENTRY OCCURS 50 TIMES.
               10  EDGE-U        PIC 99.
               10  EDGE-V        PIC 99.
               10  EDGE-WEIGHT   PIC S9(5)V9(2).

      *>----------------------------------------------------------------*
      *> Union-Find Structures
      *>----------------------------------------------------------------*
       01  PARENT-TABLE.
           05  PARENT OCCURS 10 TIMES PIC 99.

       01  RANK-TABLE.
           05  RANK   OCCURS 10 TIMES PIC 99.

      *>----------------------------------------------------------------*
      *> Cheapest Edge per Tree
      *>----------------------------------------------------------------*
       01  CHEAPEST-TABLE.
           05  CHEAPEST-ENTRY OCCURS 10 TIMES.
               10  CHEAP-U       PIC S99 VALUE -1.
               10  CHEAP-V       PIC S99 VALUE -1.
               10  CHEAP-WEIGHT  PIC S9(5)V9(2) VALUE -1.00.

      *>----------------------------------------------------------------*
      *> Algorithm Working Variables
      *>----------------------------------------------------------------*
       01  TREE-COUNT            PIC 99 VALUE 0.
       01  MST-WEIGHT            PIC S9(7)V9(2) VALUE 0.
       01  WS-VERTEX             PIC 99 VALUE 0.
       01  WS-EDGE-IDX           PIC 99 VALUE 0.
       01  WS-U                  PIC 99 VALUE 0.
       01  WS-V                  PIC 99 VALUE 0.
       01  WS-WEIGHT             PIC S9(5)V9(2) VALUE 0.
       01  WS-INDEX1             PIC 99 VALUE 0.
       01  WS-INDEX2             PIC 99 VALUE 0.

      *>----------------------------------------------------------------*
      *> Find / Union Working Variables
      *>----------------------------------------------------------------*
       01  FIND-VERTEX           PIC 99 VALUE 0.
       01  FIND-RESULT           PIC 99 VALUE 0.
       01  FIND-PARENT-VAL       PIC 99 VALUE 0.
       01  UNION-U               PIC 99 VALUE 0.
       01  UNION-V               PIC 99 VALUE 0.
       01  UNION-U-ROOT          PIC 99 VALUE 0.
       01  UNION-V-ROOT          PIC 99 VALUE 0.

      *>----------------------------------------------------------------*
      *> Display Working Variables
      *>----------------------------------------------------------------*
       01  DISP-U                PIC 99.
       01  DISP-V                PIC 99.
       01  DISP-WEIGHT           PIC S9(5)V9(2).
       01  DISP-MST-WEIGHT       PIC S9(7)V9(2).

       PROCEDURE DIVISION.

      *>----------------------------------------------------------------*
      *> MAIN
      *>----------------------------------------------------------------*
       MAIN-PARA.
           PERFORM INIT-GRAPH
           PERFORM BORUVKA-MST
           STOP RUN.

      *>----------------------------------------------------------------*
      *> Initialize graph with 4 vertices and 5 edges
      *>----------------------------------------------------------------*
       INIT-GRAPH.
           MOVE 4 TO VERTEX-COUNT
           MOVE 5 TO EDGE-COUNT

           MOVE 0    TO EDGE-U(1)
           MOVE 1    TO EDGE-V(1)
           MOVE 10.0 TO EDGE-WEIGHT(1)

           MOVE 0   TO EDGE-U(2)
           MOVE 2   TO EDGE-V(2)
           MOVE 6.0 TO EDGE-WEIGHT(2)

           MOVE 0   TO EDGE-U(3)
           MOVE 3   TO EDGE-V(3)
           MOVE 5.0 TO EDGE-WEIGHT(3)

           MOVE 1    TO EDGE-U(4)
           MOVE 3    TO EDGE-V(4)
           MOVE 15.0 TO EDGE-WEIGHT(4)

           MOVE 2   TO EDGE-U(5)
           MOVE 3   TO EDGE-V(5)
           MOVE 4.0 TO EDGE-WEIGHT(5).

      *>----------------------------------------------------------------*
      *> Boruvka's Minimum Spanning Tree Algorithm
      *>----------------------------------------------------------------*
       BORUVKA-MST.
      *> Initialize parent and rank arrays
           PERFORM VARYING WS-VERTEX FROM 1 BY 1
               UNTIL WS-VERTEX > VERTEX-COUNT
               COMPUTE PARENT(WS-VERTEX) = WS-VERTEX - 1
               MOVE 0 TO RANK(WS-VERTEX)
           END-PERFORM

      *> Initialize cheapest edges
           PERFORM VARYING WS-VERTEX FROM 1 BY 1
               UNTIL WS-VERTEX > VERTEX-COUNT
               MOVE -1    TO CHEAP-U(WS-VERTEX)
               MOVE -1    TO CHEAP-V(WS-VERTEX)
               MOVE -1.00 TO CHEAP-WEIGHT(WS-VERTEX)
           END-PERFORM

           MOVE VERTEX-COUNT TO TREE-COUNT
           MOVE 0            TO MST-WEIGHT

      *> Main loop: combine trees until one MST remains
           PERFORM UNTIL TREE-COUNT <= 1

      *>     Reset cheapest edges each iteration
               PERFORM VARYING WS-VERTEX FROM 1 BY 1
                   UNTIL WS-VERTEX > VERTEX-COUNT
                   MOVE -1    TO CHEAP-U(WS-VERTEX)
                   MOVE -1    TO CHEAP-V(WS-VERTEX)
                   MOVE -1.00 TO CHEAP-WEIGHT(WS-VERTEX)
               END-PERFORM

      *>     Traverse all edges and find cheapest for each component
               PERFORM VARYING WS-EDGE-IDX FROM 1 BY 1
                   UNTIL WS-EDGE-IDX > EDGE-COUNT

                   MOVE EDGE-U(WS-EDGE-IDX)      TO WS-U
                   MOVE EDGE-V(WS-EDGE-IDX)      TO WS-V
                   MOVE EDGE-WEIGHT(WS-EDGE-IDX) TO WS-WEIGHT

      *>           Find root of U (0-based vertex => 1-based index)
                   COMPUTE FIND-VERTEX = WS-U + 1
                   PERFORM FIND-PARENT
                   MOVE FIND-RESULT TO WS-INDEX1

      *>           Find root of V
                   COMPUTE FIND-VERTEX = WS-V + 1
                   PERFORM FIND-PARENT
                   MOVE FIND-RESULT TO WS-INDEX2

      *>           If they belong to different trees, update cheapest
                   IF WS-INDEX1 NOT EQUAL WS-INDEX2
                       IF CHEAP-WEIGHT(WS-INDEX1) = -1.00
                           OR CHEAP-WEIGHT(WS-INDEX1) > WS-WEIGHT
                           MOVE WS-U     TO CHEAP-U(WS-INDEX1)
                           MOVE WS-V     TO CHEAP-V(WS-INDEX1)
                           MOVE WS-WEIGHT TO CHEAP-WEIGHT(WS-INDEX1)
                       END-IF
                       IF CHEAP-WEIGHT(WS-INDEX2) = -1.00
                           OR CHEAP-WEIGHT(WS-INDEX2) > WS-WEIGHT
                           MOVE WS-U     TO CHEAP-U(WS-INDEX2)
                           MOVE WS-V     TO CHEAP-V(WS-INDEX2)
                           MOVE WS-WEIGHT TO CHEAP-WEIGHT(WS-INDEX2)
                       END-IF
                   END-IF
               END-PERFORM

      *>     Add cheapest edges to MST
               PERFORM VARYING WS-VERTEX FROM 1 BY 1
                   UNTIL WS-VERTEX > VERTEX-COUNT

                   IF CHEAP-WEIGHT(WS-VERTEX) NOT EQUAL -1.00

                       MOVE CHEAP-U(WS-VERTEX)      TO WS-U
                       MOVE CHEAP-V(WS-VERTEX)      TO WS-V
                       MOVE CHEAP-WEIGHT(WS-VERTEX) TO WS-WEIGHT

                       COMPUTE FIND-VERTEX = WS-U + 1
                       PERFORM FIND-PARENT
                       MOVE FIND-RESULT TO WS-INDEX1

                       COMPUTE FIND-VERTEX = WS-V + 1
                       PERFORM FIND-PARENT
                       MOVE FIND-RESULT TO WS-INDEX2

                       IF WS-INDEX1 NOT EQUAL WS-INDEX2
                           ADD WS-WEIGHT TO MST-WEIGHT

                           MOVE WS-INDEX1 TO UNION-U
                           MOVE WS-INDEX2 TO UNION-V
                           PERFORM UNION-SET

                           MOVE WS-U      TO DISP-U
                           MOVE WS-V      TO DISP-V
                           MOVE WS-WEIGHT TO DISP-WEIGHT
                           DISPLAY "Edge " DISP-U "--" DISP-V
                               " with weight " DISP-WEIGHT
                               " is included in the minimum spanning tree"

                           SUBTRACT 1 FROM TREE-COUNT
                       END-IF
                   END-IF
               END-PERFORM
           END-PERFORM

           MOVE MST-WEIGHT TO DISP-MST-WEIGHT
           DISPLAY " "
           DISPLAY "Weight of minimum spanning tree is "
               DISP-MST-WEIGHT.

      *>----------------------------------------------------------------*
      *> FIND with path compression (iterative to avoid recursion limits)
      *> Input:  FIND-VERTEX (1-based index)
      *> Output: FIND-RESULT (1-based index of root)
      *>----------------------------------------------------------------*
       FIND-PARENT.
           MOVE FIND-VERTEX TO FIND-RESULT
           PERFORM UNTIL PARENT(FIND-RESULT) + 1 = FIND-RESULT
               COMPUTE FIND-PARENT-VAL = PARENT(FIND-RESULT) + 1
      *>         Path compression: point directly to root
               COMPUTE PARENT(FIND-RESULT) =
                   PARENT(FIND-PARENT-VAL)
               MOVE FIND-PARENT-VAL TO FIND-RESULT
           END-PERFORM.

      *>----------------------------------------------------------------*
      *> UNION by rank
      *> Input: UNION-U, UNION-V (1-based indexes of the two roots)
      *>----------------------------------------------------------------*
       UNION-SET.
           MOVE UNION-U TO UNION-U-ROOT
           MOVE UNION-V TO UNION-V-ROOT

           IF RANK(UNION-U-ROOT) < RANK(UNION-V-ROOT)
               COMPUTE PARENT(UNION-U-ROOT) = UNION-V-ROOT - 1
           ELSE IF RANK(UNION-U-ROOT) > RANK(UNION-V-ROOT)
               COMPUTE PARENT(UNION-V-ROOT) = UNION-U-ROOT - 1
           ELSE
               COMPUTE PARENT(UNION-V-ROOT) = UNION-U-ROOT - 1
               ADD 1 TO RANK(UNION-U-ROOT)
           END-IF.
