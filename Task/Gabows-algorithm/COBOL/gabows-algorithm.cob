       IDENTIFICATION DIVISION.
       PROGRAM-ID. GabowsAlgorithm.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GRAPH-DATA EXTERNAL.
          05 NUM-VERTICES PIC 9(4) COMP VALUE 13.
          05 NUM-EDGES    PIC 9(4) COMP VALUE 22.
          05 ADJ-LIST OCCURS 13 TIMES.
             10 ADJ-COUNT PIC 9(4) COMP VALUE 0.
             10 ADJ-EDGE OCCURS 25 TIMES PIC S9(4) COMP.

       01 SCC-DATA EXTERNAL.
          05 VISITED OCCURS 13 TIMES PIC X VALUE '0'.
          05 COMP-IDS OCCURS 13 TIMES PIC S9(4) COMP VALUE -1.
          05 PREORDERS OCCURS 13 TIMES PIC S9(4) COMP VALUE -1.
          05 PREORDER-COUNT PIC S9(4) COMP VALUE 0.
          05 SCC-COUNT PIC S9(4) COMP VALUE 0.
          05 V-STACK.
             10 V-TOP PIC S9(4) COMP VALUE 0.
             10 V-ITEM OCCURS 13 TIMES PIC S9(4) COMP.
          05 AUX-STACK.
             10 AUX-TOP PIC S9(4) COMP VALUE 0.
             10 AUX-ITEM OCCURS 13 TIMES PIC S9(4) COMP.

       01 TEMP-VARS.
          05 FROM-V PIC S9(4) COMP.
          05 TO-V   PIC S9(4) COMP.
          05 I      PIC 9(4) COMP.
          05 J      PIC 9(4) COMP.
          05 K      PIC 9(4) COMP.
          05 V      PIC 9(4) COMP.
          05 W      PIC S9(4) COMP.
          05 TEMP   PIC S9(4) COMP.
          05 DISP-V PIC Z9.
          05 DISP-W PIC Z9.
          05 PTR    PIC 9(4) COMP.
          05 DISP-LINE PIC X(100).
          05 SPACE-CHAR PIC X VALUE ' '.

       01 CHECK-VARS.
          05 V1 PIC S9(4) COMP.
          05 V2 PIC S9(4) COMP.
          05 V1-IDX PIC 9(4) COMP.
          05 V2-IDX PIC 9(4) COMP.

       01 SORT-LIMITS.
          05 LIMIT-I PIC 9(4) COMP.
          05 START-J PIC 9(4) COMP.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INIT-VARS.
           PERFORM INIT-EDGES.
           PERFORM PRINT-DIGRAPH.
           PERFORM RUN-GABOW.
           PERFORM PRINT-RESULTS.

           DISPLAY " "
           DISPLAY "Example connectivity checks:"
           MOVE 0 TO V1. MOVE 3 TO V2. PERFORM CHECK-CONN
           MOVE 0 TO V1. MOVE 7 TO V2. PERFORM CHECK-CONN
           MOVE 9 TO V1. MOVE 12 TO V2. PERFORM CHECK-CONN
           MOVE 5 TO V1. PERFORM PRINT-COMP-ID
           MOVE 8 TO V1. PERFORM PRINT-COMP-ID

           STOP RUN.

       INIT-VARS.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 13
               MOVE '0' TO VISITED(I)
               MOVE -1 TO COMP-IDS(I)
               MOVE -1 TO PREORDERS(I)
               MOVE 0 TO ADJ-COUNT(I)
           END-PERFORM.
           MOVE 0 TO PREORDER-COUNT.
           MOVE 0 TO SCC-COUNT.
           MOVE 0 TO V-TOP.
           MOVE 0 TO AUX-TOP.

       INIT-EDGES.
           MOVE 4 TO FROM-V. MOVE 2 TO TO-V. PERFORM ADD-EDGE.
           MOVE 2 TO FROM-V. MOVE 3 TO TO-V. PERFORM ADD-EDGE.
           MOVE 3 TO FROM-V. MOVE 2 TO TO-V. PERFORM ADD-EDGE.
           MOVE 6 TO FROM-V. MOVE 0 TO TO-V. PERFORM ADD-EDGE.
           MOVE 0 TO FROM-V. MOVE 1 TO TO-V. PERFORM ADD-EDGE.
           MOVE 2 TO FROM-V. MOVE 0 TO TO-V. PERFORM ADD-EDGE.
           MOVE 11 TO FROM-V. MOVE 12 TO TO-V. PERFORM ADD-EDGE.
           MOVE 12 TO FROM-V. MOVE 9 TO TO-V. PERFORM ADD-EDGE.
           MOVE 9 TO FROM-V. MOVE 10 TO TO-V. PERFORM ADD-EDGE.
           MOVE 9 TO FROM-V. MOVE 11 TO TO-V. PERFORM ADD-EDGE.
           MOVE 8 TO FROM-V. MOVE 9 TO TO-V. PERFORM ADD-EDGE.
           MOVE 10 TO FROM-V. MOVE 12 TO TO-V. PERFORM ADD-EDGE.
           MOVE 0 TO FROM-V. MOVE 5 TO TO-V. PERFORM ADD-EDGE.
           MOVE 5 TO FROM-V. MOVE 4 TO TO-V. PERFORM ADD-EDGE.
           MOVE 3 TO FROM-V. MOVE 5 TO TO-V. PERFORM ADD-EDGE.
           MOVE 6 TO FROM-V. MOVE 4 TO TO-V. PERFORM ADD-EDGE.
           MOVE 6 TO FROM-V. MOVE 9 TO TO-V. PERFORM ADD-EDGE.
           MOVE 7 TO FROM-V. MOVE 6 TO TO-V. PERFORM ADD-EDGE.
           MOVE 7 TO FROM-V. MOVE 8 TO TO-V. PERFORM ADD-EDGE.
           MOVE 8 TO FROM-V. MOVE 7 TO TO-V. PERFORM ADD-EDGE.
           MOVE 5 TO FROM-V. MOVE 3 TO TO-V. PERFORM ADD-EDGE.
           MOVE 0 TO FROM-V. MOVE 6 TO TO-V. PERFORM ADD-EDGE.
           .

       ADD-EDGE.
           COMPUTE I = FROM-V + 1
           ADD 1 TO ADJ-COUNT(I)
           MOVE TO-V TO ADJ-EDGE(I, ADJ-COUNT(I))
           .

       PRINT-DIGRAPH.
           DISPLAY "Constructed digraph:"
           DISPLAY "Digraph has 13 vertices and 22 edges"
           DISPLAY "Adjacency lists:"
           PERFORM VARYING V FROM 1 BY 1 UNTIL V > 13
               COMPUTE I = V - 1
               MOVE SPACES TO DISP-LINE
               MOVE 1 TO PTR
               IF I < 10
                   STRING " " DELIMITED BY SIZE
                          INTO DISP-LINE POINTER PTR
               END-IF
               MOVE I TO DISP-V
               STRING DISP-V DELIMITED BY SIZE
                      ": " DELIMITED BY SIZE
                      INTO DISP-LINE POINTER PTR

               PERFORM SORT-ADJ
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > ADJ-COUNT(V)
                   MOVE ADJ-EDGE(V, J) TO DISP-W
                   IF J > 1
                       STRING " " DELIMITED BY SIZE
                              INTO DISP-LINE POINTER PTR
                   END-IF
                   STRING DISP-W DELIMITED BY SIZE
                          INTO DISP-LINE POINTER PTR
               END-PERFORM
               DISPLAY FUNCTION TRIM(DISP-LINE TRAILING)
           END-PERFORM.

       SORT-ADJ.
           IF ADJ-COUNT(V) > 1
               COMPUTE LIMIT-I = ADJ-COUNT(V) - 1
               PERFORM VARYING I FROM 1 BY 1 UNTIL I > LIMIT-I
                   COMPUTE START-J = I + 1
                   PERFORM VARYING J FROM START-J BY 1
                           UNTIL J > ADJ-COUNT(V)
                       IF ADJ-EDGE(V, I) > ADJ-EDGE(V, J)
                           MOVE ADJ-EDGE(V, I) TO TEMP
                           MOVE ADJ-EDGE(V, J) TO ADJ-EDGE(V, I)
                           MOVE TEMP TO ADJ-EDGE(V, J)
                       END-IF
                   END-PERFORM
               END-PERFORM
           END-IF.

       RUN-GABOW.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 13
               IF VISITED(I) = '0'
                   COMPUTE W = I - 1
                   CALL "DFS-ROUTINE" USING BY CONTENT W
               END-IF
           END-PERFORM.

       PRINT-RESULTS.
           MOVE SCC-COUNT TO DISP-V
           MOVE SPACES TO DISP-LINE
           MOVE 1 TO PTR
           STRING "It has " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-V) DELIMITED BY SIZE
                  " strongly connected components." DELIMITED BY SIZE
                  INTO DISP-LINE POINTER PTR
           DISPLAY FUNCTION TRIM(DISP-LINE TRAILING)

           DISPLAY " "
           DISPLAY "Components:"

           PERFORM VARYING I FROM 0 BY 1 UNTIL I = SCC-COUNT
               MOVE SPACES TO DISP-LINE
               MOVE 1 TO PTR
               MOVE I TO DISP-V
               STRING "Component " DELIMITED BY SIZE
                      FUNCTION TRIM(DISP-V) DELIMITED BY SIZE
                      ": " DELIMITED BY SIZE
                      INTO DISP-LINE POINTER PTR

               MOVE 0 TO K
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > 13
                   IF COMP-IDS(J) = I
                       COMPUTE W = J - 1
                       MOVE W TO DISP-W
                       IF K > 0
                           STRING " " DELIMITED BY SIZE
                                  INTO DISP-LINE POINTER PTR
                       END-IF
                       STRING FUNCTION TRIM(DISP-W) DELIMITED BY SIZE
                              INTO DISP-LINE POINTER PTR
                       ADD 1 TO K
                   END-IF
               END-PERFORM
               DISPLAY FUNCTION TRIM(DISP-LINE TRAILING)
           END-PERFORM.

       CHECK-CONN.
           COMPUTE V1-IDX = V1 + 1
           COMPUTE V2-IDX = V2 + 1
           MOVE V1 TO DISP-V
           MOVE V2 TO DISP-W
           MOVE SPACES TO DISP-LINE
           MOVE 1 TO PTR
           STRING "Vertices " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-V) DELIMITED BY SIZE
                  " and " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-W) DELIMITED BY SIZE
                  INTO DISP-LINE POINTER PTR

           IF COMP-IDS(V1-IDX) NOT = -1 AND
              COMP-IDS(V1-IDX) = COMP-IDS(V2-IDX)
               STRING " strongly connected? true" DELIMITED BY SIZE
                      INTO DISP-LINE POINTER PTR
           ELSE
               STRING " strongly connected? false" DELIMITED BY SIZE
                      INTO DISP-LINE POINTER PTR
           END-IF
           DISPLAY FUNCTION TRIM(DISP-LINE TRAILING).

       PRINT-COMP-ID.
           COMPUTE V1-IDX = V1 + 1
           MOVE V1 TO DISP-V
           MOVE COMP-IDS(V1-IDX) TO DISP-W
           MOVE SPACES TO DISP-LINE
           MOVE 1 TO PTR
           STRING "Component ID of vertex " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-V) DELIMITED BY SIZE
                  ": " DELIMITED BY SIZE
                  FUNCTION TRIM(DISP-W) DELIMITED BY SIZE
                  INTO DISP-LINE POINTER PTR
           DISPLAY FUNCTION TRIM(DISP-LINE TRAILING).
       END PROGRAM GabowsAlgorithm.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. DFS-ROUTINE RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GRAPH-DATA EXTERNAL.
          05 NUM-VERTICES PIC 9(4) COMP VALUE 13.
          05 NUM-EDGES    PIC 9(4) COMP VALUE 22.
          05 ADJ-LIST OCCURS 13 TIMES.
             10 ADJ-COUNT PIC 9(4) COMP VALUE 0.
             10 ADJ-EDGE OCCURS 25 TIMES PIC S9(4) COMP.

       01 SCC-DATA EXTERNAL.
          05 VISITED OCCURS 13 TIMES PIC X VALUE '0'.
          05 COMP-IDS OCCURS 13 TIMES PIC S9(4) COMP VALUE -1.
          05 PREORDERS OCCURS 13 TIMES PIC S9(4) COMP VALUE -1.
          05 PREORDER-COUNT PIC S9(4) COMP VALUE 0.
          05 SCC-COUNT PIC S9(4) COMP VALUE 0.
          05 V-STACK.
             10 V-TOP PIC S9(4) COMP VALUE 0.
             10 V-ITEM OCCURS 13 TIMES PIC S9(4) COMP.
          05 AUX-STACK.
             10 AUX-TOP PIC S9(4) COMP VALUE 0.
             10 AUX-ITEM OCCURS 13 TIMES PIC S9(4) COMP.

       LOCAL-STORAGE SECTION.
       01 LOCAL-I PIC 9(4) COMP.
       01 W PIC S9(4) COMP.
       01 W-IDX PIC 9(4) COMP.
       01 V-IDX PIC 9(4) COMP.
       01 AUX-PEEK PIC S9(4) COMP.
       01 AUX-PEEK-IDX PIC 9(4) COMP.
       01 V-POPPED PIC S9(4) COMP.
       LINKAGE SECTION.
       01 VERTEX PIC S9(4) COMP.
       PROCEDURE DIVISION USING VERTEX.
       MAIN-DFS.
           COMPUTE V-IDX = VERTEX + 1
           MOVE '1' TO VISITED(V-IDX)
           MOVE PREORDER-COUNT TO PREORDERS(V-IDX)
           ADD 1 TO PREORDER-COUNT

           ADD 1 TO V-TOP
           MOVE VERTEX TO V-ITEM(V-TOP)

           ADD 1 TO AUX-TOP
           MOVE VERTEX TO AUX-ITEM(AUX-TOP)

           PERFORM VARYING LOCAL-I FROM 1 BY 1
                   UNTIL LOCAL-I > ADJ-COUNT(V-IDX)
               MOVE ADJ-EDGE(V-IDX, LOCAL-I) TO W
               COMPUTE W-IDX = W + 1
               IF VISITED(W-IDX) = '0'
                   CALL "DFS-ROUTINE" USING BY CONTENT W
               ELSE IF COMP-IDS(W-IDX) = -1
                   PERFORM UNTIL AUX-TOP = 0
                       MOVE AUX-ITEM(AUX-TOP) TO AUX-PEEK
                       COMPUTE AUX-PEEK-IDX = AUX-PEEK + 1
                       IF PREORDERS(AUX-PEEK-IDX) > PREORDERS(W-IDX)
                           SUBTRACT 1 FROM AUX-TOP
                       ELSE
                           EXIT PERFORM
                       END-IF
                   END-PERFORM
               END-IF
           END-PERFORM

           IF AUX-TOP > 0 AND AUX-ITEM(AUX-TOP) = VERTEX
               SUBTRACT 1 FROM AUX-TOP
               PERFORM UNTIL V-TOP = 0
                   MOVE V-ITEM(V-TOP) TO V-POPPED
                   SUBTRACT 1 FROM V-TOP
                   COMPUTE W-IDX = V-POPPED + 1
                   MOVE SCC-COUNT TO COMP-IDS(W-IDX)
                   IF V-POPPED = VERTEX
                       EXIT PERFORM
                   END-IF
               END-PERFORM
               ADD 1 TO SCC-COUNT
           END-IF
           .
       END PROGRAM DFS-ROUTINE.

