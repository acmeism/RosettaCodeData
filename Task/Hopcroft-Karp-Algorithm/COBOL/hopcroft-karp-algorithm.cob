IDENTIFICATION DIVISION.
       PROGRAM-ID. HOPCROFT-KARP.
       AUTHOR. TRANSLATED-FROM-JAVA.

      *>================================================================
      *> Hopcroft-Karp Maximum Bipartite Matching Algorithm
      *>
      *> Left partition U: vertices 1..M
      *> Right partition V: vertices 1..N
      *>
      *> Limitations of this COBOL implementation:
      *>   MAX-M   = max vertices in U (left)
      *>   MAX-N   = max vertices in V (right)
      *>   MAX-ADJ = max total directed edges
      *>   QUEUE   = BFS queue size
      *>================================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. ANY-COMPUTER.
       OBJECT-COMPUTER. ANY-COMPUTER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *>--- Graph dimensions ---
       01  WS-M            PIC 9(4) VALUE 0.
       01  WS-N            PIC 9(4) VALUE 0.
       01  WS-MATCH-SIZE   PIC 9(4) VALUE 0.

      *>--- Constants ---
       01  WS-NIL          PIC 9(4) VALUE 0.
       01  WS-INFINITY     PIC 9(9) VALUE 999999999.
       01  WS-MAX-M        PIC 9(4) VALUE 50.
       01  WS-MAX-N        PIC 9(4) VALUE 50.
       01  WS-MAX-ADJ      PIC 9(6) VALUE 2500.

      *>--- Adjacency list (CSR-style): adj-dest(i) = destination vertex
      *>    adj-start(u) = first index in adj-dest for vertex u
      *>    adj-end(u)   = one past last index                     ---
       01  WS-ADJ-DEST     OCCURS 2500 TIMES PIC 9(4) VALUE 0.
       01  WS-ADJ-COUNT    PIC 9(6) VALUE 0.

      *>--- Per-vertex adjacency bounds (indexed 0..MAX-M) ---
       01  WS-ADJ-START    OCCURS 51 TIMES PIC 9(6) VALUE 0.
       01  WS-ADJ-LEN      OCCURS 51 TIMES PIC 9(4) VALUE 0.

      *>--- Temporary edge list before building CSR ---
       01  WS-EDGE-TABLE.
           05  WS-EDGE     OCCURS 2500 TIMES.
               10  WS-EDGE-FROM  PIC 9(4) VALUE 0.
               10  WS-EDGE-TO    PIC 9(4) VALUE 0.
       01  WS-EDGE-COUNT   PIC 9(6) VALUE 0.

      *>--- Matching arrays ---
       01  WS-PAIR-U       OCCURS 51 TIMES PIC 9(4) VALUE 0.
       01  WS-PAIR-V       OCCURS 51 TIMES PIC 9(4) VALUE 0.

      *>--- Level array (indexed 0..MAX-M, index 0 = NIL node) ---
       01  WS-LEVEL        OCCURS 51 TIMES PIC 9(9) VALUE 0.

      *>--- BFS Queue ---
       01  WS-QUEUE        OCCURS 5100 TIMES PIC 9(4) VALUE 0.
       01  WS-Q-HEAD       PIC 9(6) VALUE 1.
       01  WS-Q-TAIL       PIC 9(6) VALUE 0.

      *>--- Loop / work variables ---
       01  WS-U            PIC 9(4) VALUE 0.
       01  WS-V            PIC 9(4) VALUE 0.
       01  WS-MATCHED-U    PIC 9(4) VALUE 0.
       01  WS-BFS-RESULT   PIC 9(1) VALUE 0.
       01  WS-DFS-RESULT   PIC 9(1) VALUE 0.
       01  WS-I            PIC 9(6) VALUE 0.
       01  WS-J            PIC 9(4) VALUE 0.
       01  WS-IDX          PIC 9(6) VALUE 0.

      *>--- DFS recursion stack (simulate recursion) ---
       01  WS-STACK        OCCURS 51 TIMES PIC 9(4) VALUE 0.
       01  WS-STACK-POS    OCCURS 51 TIMES PIC 9(6) VALUE 0.
       01  WS-STACK-TOP    PIC 9(4) VALUE 0.
       01  WS-STACK-V      PIC 9(4) VALUE 0.
       01  WS-STACK-U2     PIC 9(4) VALUE 0.

      *>--- Test harness ---
       01  WS-TEST-NUM     PIC 9(2) VALUE 0.
       01  WS-EXPECTED     PIC 9(4) VALUE 0.
       01  WS-SUCCESS-CNT  PIC 9(2) VALUE 0.
       01  WS-PASS-FAIL    PIC X(6) VALUE SPACES.
       01  WS-ALL-PASS     PIC 9(2) VALUE 5.

      *>--- Display work ---
       01  WS-DISP-NUM     PIC Z(4).

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY "Running tests:"
           MOVE 0 TO WS-SUCCESS-CNT

      *>--- Test 1: M=3 N=5, edge (1,4), expected=1 ---
           MOVE 1 TO WS-TEST-NUM
           MOVE 3 TO WS-M
           MOVE 5 TO WS-N
           MOVE 0 TO WS-EDGE-COUNT
           PERFORM INIT-EDGE-TABLE
           MOVE 1 TO WS-EDGE-COUNT
           MOVE 1 TO WS-EDGE-FROM(1)
           MOVE 4 TO WS-EDGE-TO(1)
           MOVE 1 TO WS-EXPECTED
           PERFORM RUN-TEST
           ADD WS-DFS-RESULT TO WS-SUCCESS-CNT

      *>--- Test 2: M=6 N=6, edges (1,4)(1,5)(5,1), expected=2 ---
           MOVE 2 TO WS-TEST-NUM
           MOVE 6 TO WS-M
           MOVE 6 TO WS-N
           PERFORM INIT-EDGE-TABLE
           MOVE 3 TO WS-EDGE-COUNT
           MOVE 1 TO WS-EDGE-FROM(1)
           MOVE 4 TO WS-EDGE-TO(1)
           MOVE 1 TO WS-EDGE-FROM(2)
           MOVE 5 TO WS-EDGE-TO(2)
           MOVE 5 TO WS-EDGE-FROM(3)
           MOVE 1 TO WS-EDGE-TO(3)
           MOVE 2 TO WS-EXPECTED
           PERFORM RUN-TEST
           ADD WS-DFS-RESULT TO WS-SUCCESS-CNT

      *>--- Test 3: K(3,3) complete bipartite, expected=3 ---
           MOVE 3 TO WS-TEST-NUM
           MOVE 3 TO WS-M
           MOVE 3 TO WS-N
           PERFORM INIT-EDGE-TABLE
           MOVE 0 TO WS-EDGE-COUNT
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 3
               PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > 3
                   ADD 1 TO WS-EDGE-COUNT
                   MOVE WS-I TO WS-EDGE-FROM(WS-EDGE-COUNT)
                   MOVE WS-J TO WS-EDGE-TO(WS-EDGE-COUNT)
               END-PERFORM
           END-PERFORM
           MOVE 3 TO WS-EXPECTED
           PERFORM RUN-TEST
           ADD WS-DFS-RESULT TO WS-SUCCESS-CNT

      *>--- Test 4: No edges, expected=0 ---
           MOVE 4 TO WS-TEST-NUM
           MOVE 2 TO WS-M
           MOVE 2 TO WS-N
           PERFORM INIT-EDGE-TABLE
           MOVE 0 TO WS-EDGE-COUNT
           MOVE 0 TO WS-EXPECTED
           PERFORM RUN-TEST
           ADD WS-DFS-RESULT TO WS-SUCCESS-CNT

      *>--- Test 5: M=4 N=4, 6 edges, expected=4 ---
           MOVE 5 TO WS-TEST-NUM
           MOVE 4 TO WS-M
           MOVE 4 TO WS-N
           PERFORM INIT-EDGE-TABLE
           MOVE 6 TO WS-EDGE-COUNT
           MOVE 1 TO WS-EDGE-FROM(1)  MOVE 1 TO WS-EDGE-TO(1)
           MOVE 1 TO WS-EDGE-FROM(2)  MOVE 3 TO WS-EDGE-TO(2)
           MOVE 2 TO WS-EDGE-FROM(3)  MOVE 3 TO WS-EDGE-TO(3)
           MOVE 3 TO WS-EDGE-FROM(4)  MOVE 4 TO WS-EDGE-TO(4)
           MOVE 4 TO WS-EDGE-FROM(5)  MOVE 3 TO WS-EDGE-TO(5)
           MOVE 4 TO WS-EDGE-FROM(6)  MOVE 2 TO WS-EDGE-TO(6)
           MOVE 4 TO WS-EXPECTED
           PERFORM RUN-TEST
           ADD WS-DFS-RESULT TO WS-SUCCESS-CNT

           IF WS-SUCCESS-CNT = WS-ALL-PASS
               DISPLAY "All tests passed."
           END-IF

           STOP RUN.

      *>================================================================
      *> INIT-EDGE-TABLE: clear edge staging area
      *>================================================================
       INIT-EDGE-TABLE.
           MOVE 0 TO WS-EDGE-COUNT
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 2500
               MOVE 0 TO WS-EDGE-FROM(WS-EDGE-COUNT + 1)
               MOVE 0 TO WS-EDGE-TO(WS-EDGE-COUNT + 1)
               ADD 1 TO WS-EDGE-COUNT
           END-PERFORM
           MOVE 0 TO WS-EDGE-COUNT.

      *>================================================================
      *> RUN-TEST: build graph from edge table, run algorithm, report
      *>   Input:  WS-M, WS-N, WS-EDGE-COUNT/FROM/TO, WS-EXPECTED
      *>   Output: WS-DFS-RESULT = 1 if passed, 0 if failed
      *>================================================================
       RUN-TEST.
           PERFORM BUILD-GRAPH
           PERFORM HOPCROFT-KARP
           MOVE WS-DISP-NUM TO WS-DISP-NUM
           MOVE WS-MATCH-SIZE TO WS-DISP-NUM
           IF WS-MATCH-SIZE = WS-EXPECTED
               MOVE "PASSED" TO WS-PASS-FAIL
               MOVE 1 TO WS-DFS-RESULT
           ELSE
               MOVE "FAILED" TO WS-PASS-FAIL
               MOVE 0 TO WS-DFS-RESULT
           END-IF
           DISPLAY "Test " WS-TEST-NUM ": Result = " WS-MATCH-SIZE
               " Expected = " WS-EXPECTED " " WS-PASS-FAIL.

      *>================================================================
      *> BUILD-GRAPH: convert edge list to CSR adjacency structure
      *>================================================================
       BUILD-GRAPH.
      *> Clear adjacency lengths
           PERFORM VARYING WS-I FROM 0 BY 1 UNTIL WS-I > 50
               MOVE 0 TO WS-ADJ-LEN(WS-I + 1)
           END-PERFORM

      *> Count edges per source vertex
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-EDGE-COUNT
               MOVE WS-EDGE-FROM(WS-I) TO WS-U
               ADD 1 TO WS-ADJ-LEN(WS-U + 1)
           END-PERFORM

      *> Compute start offsets (1-based in adj-dest)
           MOVE 1 TO WS-ADJ-START(1)       *> index 0 = NIL, unused
           MOVE 1 TO WS-ADJ-START(2)       *> vertex 1 starts at 1
           PERFORM VARYING WS-U FROM 1 BY 1 UNTIL WS-U > 49
               COMPUTE WS-ADJ-START(WS-U + 2) =
                   WS-ADJ-START(WS-U + 1) + WS-ADJ-LEN(WS-U + 1)
           END-PERFORM

      *> Place edges into adj-dest; use a temp cursor array
           PERFORM VARYING WS-U FROM 0 BY 1 UNTIL WS-U > 50
               MOVE WS-ADJ-START(WS-U + 1) TO WS-ADJ-LEN(WS-U + 1)
           END-PERFORM
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-EDGE-COUNT
               MOVE WS-EDGE-FROM(WS-I) TO WS-U
               MOVE WS-EDGE-TO(WS-I)   TO WS-V
               MOVE WS-ADJ-LEN(WS-U + 1) TO WS-IDX
               MOVE WS-V TO WS-ADJ-DEST(WS-IDX)
               ADD 1 TO WS-ADJ-LEN(WS-U + 1)
           END-PERFORM.

      *>================================================================
      *> HOPCROFT-KARP: main algorithm
      *>================================================================
       HOPCROFT-KARP.
      *> Initialise pairU and pairV to NIL
           PERFORM VARYING WS-U FROM 0 BY 1 UNTIL WS-U > 50
               MOVE 0 TO WS-PAIR-U(WS-U + 1)
               MOVE 0 TO WS-PAIR-V(WS-U + 1)
           END-PERFORM
           MOVE 0 TO WS-MATCH-SIZE

           PERFORM BFS-PHASE
           PERFORM UNTIL WS-BFS-RESULT = 0
               PERFORM VARYING WS-U FROM 1 BY 1 UNTIL WS-U > WS-M
                   IF WS-PAIR-U(WS-U + 1) = WS-NIL
                       PERFORM DFS-PHASE
                       IF WS-DFS-RESULT = 1
                           ADD 1 TO WS-MATCH-SIZE
                       END-IF
                   END-IF
               END-PERFORM
               PERFORM BFS-PHASE
           END-PERFORM.

      *>================================================================
      *> BFS-PHASE: layered BFS over free vertices in U
      *>   Sets WS-BFS-RESULT = 1 if augmenting path found, else 0
      *>   Uses WS-U as loop variable (saved/restored via WS-STACK)
      *>================================================================
       BFS-PHASE.
           MOVE 1 TO WS-Q-HEAD
           MOVE 0 TO WS-Q-TAIL

      *> Initialise levels
           PERFORM VARYING WS-U FROM 0 BY 1 UNTIL WS-U > 50
               MOVE WS-INFINITY TO WS-LEVEL(WS-U + 1)
           END-PERFORM

      *> Enqueue free vertices of U
           PERFORM VARYING WS-U FROM 1 BY 1 UNTIL WS-U > WS-M
               IF WS-PAIR-U(WS-U + 1) = WS-NIL
                   MOVE 0 TO WS-LEVEL(WS-U + 1)
                   ADD 1 TO WS-Q-TAIL
                   MOVE WS-U TO WS-QUEUE(WS-Q-TAIL)
               END-IF
           END-PERFORM

      *> BFS loop
           PERFORM UNTIL WS-Q-HEAD > WS-Q-TAIL
               MOVE WS-QUEUE(WS-Q-HEAD) TO WS-U
               ADD 1 TO WS-Q-HEAD
               IF WS-LEVEL(WS-U + 1) < WS-LEVEL(1)
      *>            1 = index for NIL (index 0+1)
                   PERFORM VARYING WS-IDX FROM WS-ADJ-START(WS-U + 1)
                                   BY 1
                                   UNTIL WS-IDX >=
                                         WS-ADJ-START(WS-U + 2)
                       MOVE WS-ADJ-DEST(WS-IDX) TO WS-V
                       MOVE WS-PAIR-V(WS-V + 1) TO WS-MATCHED-U
                       IF WS-LEVEL(WS-MATCHED-U + 1) = WS-INFINITY
                           COMPUTE WS-LEVEL(WS-MATCHED-U + 1) =
                               WS-LEVEL(WS-U + 1) + 1
                           IF WS-MATCHED-U NOT = WS-NIL
                               ADD 1 TO WS-Q-TAIL
                               MOVE WS-MATCHED-U TO
                                   WS-QUEUE(WS-Q-TAIL)
                           END-IF
                       END-IF
                   END-PERFORM
               END-IF
           END-PERFORM

           IF WS-LEVEL(1) = WS-INFINITY
               MOVE 0 TO WS-BFS-RESULT
           ELSE
               MOVE 1 TO WS-BFS-RESULT
           END-IF.

      *>================================================================
      *> DFS-PHASE: augmenting path DFS from vertex WS-U
      *>   Input:  WS-U  (the starting free vertex)
      *>   Output: WS-DFS-RESULT = 1 if augmenting path found, 0 if not
      *>
      *>   We simulate the recursive DFS with an explicit stack.
      *>   WS-STACK(k)     = current U-node at depth k
      *>   WS-STACK-POS(k) = next adj-list index to try at depth k
      *>================================================================
       DFS-PHASE.
           MOVE 1 TO WS-STACK-TOP
           MOVE WS-U TO WS-STACK(1)
           MOVE WS-ADJ-START(WS-U + 1) TO WS-STACK-POS(1)
           MOVE 0 TO WS-DFS-RESULT

           PERFORM UNTIL WS-STACK-TOP = 0
               MOVE WS-STACK(WS-STACK-TOP)     TO WS-STACK-U2
               MOVE WS-STACK-POS(WS-STACK-TOP) TO WS-IDX

               IF WS-STACK-U2 = WS-NIL
      *>            Reached NIL: augmenting path found; unwind
                   MOVE 1 TO WS-DFS-RESULT
                   SUBTRACT 1 FROM WS-STACK-TOP
                   PERFORM UNTIL WS-STACK-TOP = 0
      *>                Pair the edge we followed to reach NIL parent
                       MOVE WS-STACK-TOP TO WS-J
                       SUBTRACT 1 FROM WS-STACK-POS(WS-J)
                       MOVE WS-STACK-POS(WS-J) TO WS-IDX
                       MOVE WS-ADJ-DEST(WS-IDX) TO WS-STACK-V
                       MOVE WS-STACK(WS-J) TO WS-U
                       MOVE WS-U TO WS-PAIR-V(WS-STACK-V + 1)
                       MOVE WS-STACK-V TO WS-PAIR-U(WS-U + 1)
                       SUBTRACT 1 FROM WS-STACK-TOP
                   END-PERFORM
               ELSE
      *>            Try next edge from WS-STACK-U2
                   IF WS-IDX < WS-ADJ-START(WS-STACK-U2 + 2)
                       MOVE WS-ADJ-DEST(WS-IDX) TO WS-V
                       ADD 1 TO WS-STACK-POS(WS-STACK-TOP)
                       MOVE WS-PAIR-V(WS-V + 1) TO WS-MATCHED-U
                       IF WS-LEVEL(WS-MATCHED-U + 1) =
                               WS-LEVEL(WS-STACK-U2 + 1) + 1
      *>                    Follow this edge: push matched-U onto stack
                           ADD 1 TO WS-STACK-TOP
                           MOVE WS-MATCHED-U TO WS-STACK(WS-STACK-TOP)
                           IF WS-MATCHED-U = WS-NIL
                               MOVE 1 TO
                                   WS-STACK-POS(WS-STACK-TOP)
                           ELSE
                               MOVE WS-ADJ-START(WS-MATCHED-U + 1) TO
                                   WS-STACK-POS(WS-STACK-TOP)
                           END-IF
                       END-IF
                   ELSE
      *>                No more edges: dead end, set level to infinity
                       MOVE WS-INFINITY TO
                           WS-LEVEL(WS-STACK-U2 + 1)
                       SUBTRACT 1 FROM WS-STACK-TOP
                   END-IF
               END-IF
           END-PERFORM.

       END PROGRAM HOPCROFT-KARP.
