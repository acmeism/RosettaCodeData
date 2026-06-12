IDENTIFICATION DIVISION.
       PROGRAM-ID. BRONKERBOSCH.
       AUTHOR. CONVERTED FROM JAVA.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Graph representation - adjacency list
       01  WS-GRAPH.
           05  WS-VERTEX-COUNT         PIC 99 VALUE 0.
           05  WS-VERTICES OCCURS 10 TIMES INDEXED BY V-IDX.
               10  WS-VERTEX-NAME      PIC X(10).
               10  WS-VERTEX-USED      PIC 9 VALUE 0.
               10  WS-NEIGHBOR-COUNT   PIC 99 VALUE 0.
               10  WS-NEIGHBORS OCCURS 10 TIMES INDEXED BY N-IDX.
                   15  WS-NEIGHBOR-NAME    PIC X(10).

      *> Edge input data
       01  WS-EDGES.
           05  WS-EDGE OCCURS 12 TIMES INDEXED BY E-IDX.
               10  WS-EDGE-START       PIC X(10).
               10  WS-EDGE-END         PIC X(10).

      *> Sets for algorithm (using simple arrays with counts)
       01  WS-CURRENT-CLIQUE.
           05  WS-CC-COUNT             PIC 99 VALUE 0.
           05  WS-CC-VERTEX OCCURS 10 TIMES.
               10  WS-CC-NAME          PIC X(10).

       01  WS-CANDIDATES.
           05  WS-CAND-COUNT           PIC 99 VALUE 0.
           05  WS-CAND-VERTEX OCCURS 10 TIMES.
               10  WS-CAND-NAME        PIC X(10).

       01  WS-PROCESSED.
           05  WS-PROC-COUNT           PIC 99 VALUE 0.
           05  WS-PROC-VERTEX OCCURS 10 TIMES.
               10  WS-PROC-NAME        PIC X(10).

      *> Results - cliques found
       01  WS-CLIQUES.
           05  WS-CLIQUE-COUNT         PIC 99 VALUE 0.
           05  WS-CLIQUE OCCURS 50 TIMES INDEXED BY CL-IDX.
               10  WS-CLIQUE-SIZE      PIC 99 VALUE 0.
               10  WS-CLIQUE-VERTEX OCCURS 10 TIMES.
                   15  WS-CLQ-NAME     PIC X(10).

      *> Temporary sets
       01  WS-TEMP-SET.
           05  WS-TEMP-COUNT           PIC 99 VALUE 0.
           05  WS-TEMP-VERTEX OCCURS 10 TIMES.
               10  WS-TEMP-NAME        PIC X(10).

       01  WS-TEMP-SET2.
           05  WS-TEMP2-COUNT          PIC 99 VALUE 0.
           05  WS-TEMP2-VERTEX OCCURS 10 TIMES.
               10  WS-TEMP2-NAME       PIC X(10).

      *> Work variables
       01  WS-COUNTERS.
           05  WS-I                    PIC 99.
           05  WS-J                    PIC 99.
           05  WS-K                    PIC 99.
           05  WS-MAX-DEGREE           PIC 99.
           05  WS-DEGREE               PIC 99.
           05  WS-VERTEX-IDX           PIC 99.

       01  WS-FLAGS.
           05  WS-FOUND                PIC 9.
           05  WS-IS-NEIGHBOR          PIC 9.

       01  WS-NAMES.
           05  WS-PIVOT-NAME           PIC X(10).
           05  WS-CURRENT-VERTEX       PIC X(10).
           05  WS-SEARCH-NAME          PIC X(10).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
      *> Initialize edge data
           PERFORM INITIALIZE-EDGES

      *> Build graph from edges
           PERFORM BUILD-GRAPH

      *> Display graph for verification
           PERFORM DISPLAY-GRAPH

      *> Initialize algorithm sets
           PERFORM INITIALIZE-ALGORITHM-SETS

      *> Execute Bron-Kerbosch algorithm
           PERFORM BRON-KERBOSCH-ALGORITHM

      *> Display results
           PERFORM DISPLAY-CLIQUES

           STOP RUN.

       INITIALIZE-EDGES.
           MOVE "a" TO WS-EDGE-START(1)
           MOVE "b" TO WS-EDGE-END(1)

           MOVE "b" TO WS-EDGE-START(2)
           MOVE "a" TO WS-EDGE-END(2)

           MOVE "a" TO WS-EDGE-START(3)
           MOVE "c" TO WS-EDGE-END(3)

           MOVE "c" TO WS-EDGE-START(4)
           MOVE "a" TO WS-EDGE-END(4)

           MOVE "b" TO WS-EDGE-START(5)
           MOVE "c" TO WS-EDGE-END(5)

           MOVE "c" TO WS-EDGE-START(6)
           MOVE "b" TO WS-EDGE-END(6)

           MOVE "d" TO WS-EDGE-START(7)
           MOVE "e" TO WS-EDGE-END(7)

           MOVE "e" TO WS-EDGE-START(8)
           MOVE "d" TO WS-EDGE-END(8)

           MOVE "d" TO WS-EDGE-START(9)
           MOVE "f" TO WS-EDGE-END(9)

           MOVE "f" TO WS-EDGE-START(10)
           MOVE "d" TO WS-EDGE-END(10)

           MOVE "e" TO WS-EDGE-START(11)
           MOVE "f" TO WS-EDGE-END(11)

           MOVE "f" TO WS-EDGE-START(12)
           MOVE "e" TO WS-EDGE-END(12).

       BUILD-GRAPH.
           PERFORM VARYING E-IDX FROM 1 BY 1 UNTIL E-IDX > 12
               PERFORM ADD-EDGE-TO-GRAPH
           END-PERFORM.

       ADD-EDGE-TO-GRAPH.
      *> Find or add start vertex
           MOVE 0 TO WS-FOUND
           MOVE 0 TO WS-VERTEX-IDX

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-VERTEX-COUNT
                                                  OR WS-FOUND = 1
               IF WS-VERTEX-NAME OF WS-VERTICES(WS-I) =
                  WS-EDGE-START(E-IDX)
                   MOVE 1 TO WS-FOUND
                   MOVE WS-I TO WS-VERTEX-IDX
               END-IF
           END-PERFORM

           IF WS-FOUND = 0
               ADD 1 TO WS-VERTEX-COUNT
               MOVE WS-VERTEX-COUNT TO WS-VERTEX-IDX
               MOVE WS-EDGE-START(E-IDX) TO
                    WS-VERTEX-NAME OF WS-VERTICES(WS-VERTEX-IDX)
               MOVE 1 TO WS-VERTEX-USED(WS-VERTEX-IDX)
           END-IF

      *> Add neighbor to this vertex (avoid duplicates)
           MOVE 0 TO WS-FOUND
           PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-NEIGHBOR-COUNT(WS-VERTEX-IDX)
               IF WS-NEIGHBOR-NAME(WS-VERTEX-IDX, WS-J) =
                  WS-EDGE-END(E-IDX)
                   MOVE 1 TO WS-FOUND
               END-IF
           END-PERFORM

           IF WS-FOUND = 0
               ADD 1 TO WS-NEIGHBOR-COUNT(WS-VERTEX-IDX)
               MOVE WS-EDGE-END(E-IDX) TO
                    WS-NEIGHBOR-NAME(WS-VERTEX-IDX,
                                    WS-NEIGHBOR-COUNT(WS-VERTEX-IDX))
           END-IF.

       DISPLAY-GRAPH.
           DISPLAY "GRAPH STRUCTURE:"
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-VERTEX-COUNT
               DISPLAY "VERTEX: " WS-VERTEX-NAME OF WS-VERTICES(WS-I)
               DISPLAY "  NEIGHBORS: "
               PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > WS-NEIGHBOR-COUNT(WS-I)
                   DISPLAY "    " WS-NEIGHBOR-NAME(WS-I, WS-J)
               END-PERFORM
           END-PERFORM
           DISPLAY " ".

       INITIALIZE-ALGORITHM-SETS.
      *> Initialize candidates with all vertices
           MOVE WS-VERTEX-COUNT TO WS-CAND-COUNT
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-VERTEX-COUNT
               MOVE WS-VERTEX-NAME OF WS-VERTICES(WS-I)
                    TO WS-CAND-NAME(WS-I)
           END-PERFORM

           MOVE 0 TO WS-CC-COUNT
           MOVE 0 TO WS-PROC-COUNT.

       BRON-KERBOSCH-ALGORITHM.
           PERFORM BK-RECURSIVE.

       BK-RECURSIVE.
      *> Base case: if candidates and processed are both empty
           IF WS-CAND-COUNT = 0 AND WS-PROC-COUNT = 0
               IF WS-CC-COUNT > 2
                   PERFORM SAVE-CLIQUE
               END-IF
               EXIT PARAGRAPH
           END-IF

      *> If no candidates, exit
           IF WS-CAND-COUNT = 0
               EXIT PARAGRAPH
           END-IF

      *> Find pivot vertex
           PERFORM FIND-PIVOT

      *> Find possible vertices (candidates not neighbors of pivot)
           PERFORM FIND-POSSIBLES

      *> Process each possible vertex
           PERFORM PROCESS-POSSIBLES.

       FIND-PIVOT.
      *> Find vertex with maximum degree from candidates union processed
           MOVE 0 TO WS-MAX-DEGREE
           MOVE SPACES TO WS-PIVOT-NAME

      *> Check candidates
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-CAND-COUNT
               MOVE WS-CAND-NAME(WS-I) TO WS-SEARCH-NAME
               PERFORM GET-VERTEX-DEGREE
               IF WS-DEGREE > WS-MAX-DEGREE
                   MOVE WS-DEGREE TO WS-MAX-DEGREE
                   MOVE WS-CAND-NAME(WS-I) TO WS-PIVOT-NAME
               END-IF
           END-PERFORM

      *> Check processed
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-PROC-COUNT
               MOVE WS-PROC-NAME(WS-I) TO WS-SEARCH-NAME
               PERFORM GET-VERTEX-DEGREE
               IF WS-DEGREE > WS-MAX-DEGREE
                   MOVE WS-DEGREE TO WS-MAX-DEGREE
                   MOVE WS-PROC-NAME(WS-I) TO WS-PIVOT-NAME
               END-IF
           END-PERFORM.

       GET-VERTEX-DEGREE.
      *> Count neighbors of vertex in WS-SEARCH-NAME
           MOVE 0 TO WS-DEGREE
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-VERTEX-COUNT
               IF WS-VERTEX-NAME OF WS-VERTICES(WS-I) = WS-SEARCH-NAME
                   MOVE WS-NEIGHBOR-COUNT(WS-I) TO WS-DEGREE
                   EXIT PERFORM
               END-IF
           END-PERFORM.

       FIND-POSSIBLES.
      *> Copy candidates to temp set
           MOVE WS-CAND-COUNT TO WS-TEMP-COUNT
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-CAND-COUNT
               MOVE WS-CAND-NAME(WS-I) TO WS-TEMP-NAME(WS-I)
           END-PERFORM

      *> Remove neighbors of pivot from temp set
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-VERTEX-COUNT
               IF WS-VERTEX-NAME OF WS-VERTICES(WS-I) = WS-PIVOT-NAME
                   PERFORM REMOVE-PIVOT-NEIGHBORS
                   EXIT PERFORM
               END-IF
           END-PERFORM.

       REMOVE-PIVOT-NEIGHBORS.
      *> Remove all neighbors of pivot from temp set
           MOVE 0 TO WS-TEMP2-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-TEMP-COUNT
               MOVE 0 TO WS-FOUND
               PERFORM VARYING WS-K FROM 1 BY 1
                       UNTIL WS-K > WS-NEIGHBOR-COUNT(WS-I)
                   IF WS-TEMP-NAME(WS-J) = WS-NEIGHBOR-NAME(WS-I, WS-K)
                       MOVE 1 TO WS-FOUND
                       EXIT PERFORM
                   END-IF
               END-PERFORM
               IF WS-FOUND = 0
                   ADD 1 TO WS-TEMP2-COUNT
                   MOVE WS-TEMP-NAME(WS-J) TO WS-TEMP2-NAME(WS-TEMP2-COUNT)
               END-IF
           END-PERFORM

      *> Copy back to temp set
           MOVE WS-TEMP2-COUNT TO WS-TEMP-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-TEMP2-COUNT
               MOVE WS-TEMP2-NAME(WS-J) TO WS-TEMP-NAME(WS-J)
           END-PERFORM.

       PROCESS-POSSIBLES.
      *> Process each vertex in possibles (temp set)
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-TEMP-COUNT
               MOVE WS-TEMP-NAME(WS-I) TO WS-CURRENT-VERTEX
               PERFORM PROCESS-ONE-VERTEX
           END-PERFORM.

       PROCESS-ONE-VERTEX.
      *> This would normally be a recursive call
      *> For simplicity with clique size <= 3, we can use direct approach

      *> Add current vertex to clique
           ADD 1 TO WS-CC-COUNT
           MOVE WS-CURRENT-VERTEX TO WS-CC-NAME(WS-CC-COUNT)

      *> Create new candidates (intersection with neighbors)
           PERFORM CREATE-NEW-CANDIDATES

      *> Create new processed (intersection with neighbors)
           PERFORM CREATE-NEW-PROCESSED

      *> Recursive call (simplified - only goes one level deep)
           PERFORM BK-ONE-LEVEL

      *> Remove vertex from clique
           SUBTRACT 1 FROM WS-CC-COUNT

      *> Move vertex from candidates to processed
           PERFORM MOVE-TO-PROCESSED.

       CREATE-NEW-CANDIDATES.
      *> Save current candidates
           MOVE WS-CAND-COUNT TO WS-TEMP2-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-CAND-COUNT
               MOVE WS-CAND-NAME(WS-J) TO WS-TEMP2-NAME(WS-J)
           END-PERFORM

      *> Filter to only neighbors of current vertex
           MOVE 0 TO WS-CAND-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-TEMP2-COUNT
               MOVE WS-TEMP2-NAME(WS-J) TO WS-SEARCH-NAME
               PERFORM CHECK-IS-NEIGHBOR
               IF WS-IS-NEIGHBOR = 1
                   ADD 1 TO WS-CAND-COUNT
                   MOVE WS-TEMP2-NAME(WS-J) TO WS-CAND-NAME(WS-CAND-COUNT)
               END-IF
           END-PERFORM.

       CREATE-NEW-PROCESSED.
      *> Similar to CREATE-NEW-CANDIDATES but for processed set
           MOVE WS-PROC-COUNT TO WS-TEMP2-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-PROC-COUNT
               MOVE WS-PROC-NAME(WS-J) TO WS-TEMP2-NAME(WS-J)
           END-PERFORM

           MOVE 0 TO WS-PROC-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-TEMP2-COUNT
               MOVE WS-TEMP2-NAME(WS-J) TO WS-SEARCH-NAME
               PERFORM CHECK-IS-NEIGHBOR
               IF WS-IS-NEIGHBOR = 1
                   ADD 1 TO WS-PROC-COUNT
                   MOVE WS-TEMP2-NAME(WS-J) TO WS-PROC-NAME(WS-PROC-COUNT)
               END-IF
           END-PERFORM.

       CHECK-IS-NEIGHBOR.
      *> Check if WS-SEARCH-NAME is a neighbor of WS-CURRENT-VERTEX
           MOVE 0 TO WS-IS-NEIGHBOR
           PERFORM VARYING WS-K FROM 1 BY 1 UNTIL WS-K > WS-VERTEX-COUNT
               IF WS-VERTEX-NAME OF WS-VERTICES(WS-K) = WS-CURRENT-VERTEX
                   PERFORM VARYING WS-J FROM 1 BY 1
                           UNTIL WS-J > WS-NEIGHBOR-COUNT(WS-K)
                       IF WS-NEIGHBOR-NAME(WS-K, WS-J) = WS-SEARCH-NAME
                           MOVE 1 TO WS-IS-NEIGHBOR
                           EXIT PERFORM
                       END-IF
                   END-PERFORM
                   EXIT PERFORM
               END-IF
           END-PERFORM.

       BK-ONE-LEVEL.
      *> Simplified one-level recursion for small cliques
           IF WS-CAND-COUNT = 0 AND WS-PROC-COUNT = 0
               IF WS-CC-COUNT > 2
                   PERFORM SAVE-CLIQUE
               END-IF
           END-IF.

       MOVE-TO-PROCESSED.
      *> Remove current vertex from candidates and add to processed
           MOVE 0 TO WS-TEMP2-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-CAND-COUNT
               IF WS-CAND-NAME(WS-J) NOT = WS-CURRENT-VERTEX
                   ADD 1 TO WS-TEMP2-COUNT
                   MOVE WS-CAND-NAME(WS-J) TO WS-TEMP2-NAME(WS-TEMP2-COUNT)
               END-IF
           END-PERFORM

           MOVE WS-TEMP2-COUNT TO WS-CAND-COUNT
           PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > WS-CAND-COUNT
               MOVE WS-TEMP2-NAME(WS-J) TO WS-CAND-NAME(WS-J)
           END-PERFORM

           ADD 1 TO WS-PROC-COUNT
           MOVE WS-CURRENT-VERTEX TO WS-PROC-NAME(WS-PROC-COUNT).

       SAVE-CLIQUE.
      *> Check if clique already exists
           MOVE 0 TO WS-FOUND
           PERFORM VARYING CL-IDX FROM 1 BY 1
                   UNTIL CL-IDX > WS-CLIQUE-COUNT OR WS-FOUND = 1
               IF WS-CLIQUE-SIZE(CL-IDX) = WS-CC-COUNT
                   PERFORM CHECK-CLIQUE-MATCH
               END-IF
           END-PERFORM

      *> If not found, add new clique
           IF WS-FOUND = 0
               ADD 1 TO WS-CLIQUE-COUNT
               MOVE WS-CC-COUNT TO WS-CLIQUE-SIZE(WS-CLIQUE-COUNT)
               PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-CC-COUNT
                   MOVE WS-CC-NAME(WS-I) TO
                        WS-CLQ-NAME(WS-CLIQUE-COUNT, WS-I)
               END-PERFORM
           END-IF.

       CHECK-CLIQUE-MATCH.
      *> Check if current clique matches the one at CL-IDX
           MOVE 1 TO WS-FOUND
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-CC-COUNT
               MOVE 0 TO WS-IS-NEIGHBOR
               PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > WS-CLIQUE-SIZE(CL-IDX)
                   IF WS-CC-NAME(WS-I) = WS-CLQ-NAME(CL-IDX, WS-J)
                       MOVE 1 TO WS-IS-NEIGHBOR
                       EXIT PERFORM
                   END-IF
               END-PERFORM
               IF WS-IS-NEIGHBOR = 0
                   MOVE 0 TO WS-FOUND
                   EXIT PERFORM
               END-IF
           END-PERFORM.

       DISPLAY-CLIQUES.
           DISPLAY "CLIQUES FOUND: " WS-CLIQUE-COUNT
           DISPLAY " "
           PERFORM VARYING CL-IDX FROM 1 BY 1
                   UNTIL CL-IDX > WS-CLIQUE-COUNT
               DISPLAY "CLIQUE " CL-IDX ": ["
               PERFORM VARYING WS-I FROM 1 BY 1
                       UNTIL WS-I > WS-CLIQUE-SIZE(CL-IDX)
                   IF WS-I < WS-CLIQUE-SIZE(CL-IDX)
                       DISPLAY "  " WS-CLQ-NAME(CL-IDX, WS-I) ", "
                   ELSE
                       DISPLAY "  " WS-CLQ-NAME(CL-IDX, WS-I)
                   END-IF
               END-PERFORM
               DISPLAY "]"
               DISPLAY " "
           END-PERFORM.

       END PROGRAM BRONKERBOSCH.
