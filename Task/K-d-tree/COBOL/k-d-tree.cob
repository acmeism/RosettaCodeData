       IDENTIFICATION DIVISION.
       PROGRAM-ID. KD-TREE-TEST.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 KD-TREE-STATE.
          05 NUM-DIMENSIONS     PIC 9(4) COMP.
          05 TOTAL-NODES        PIC 9(6) COMP.
          05 TREE-ROOT          PIC 9(6) COMP.
          05 BEST-NODE          PIC 9(6) COMP.
          05 BEST-DISTANCE      COMP-2.
          05 VISITED-COUNT      PIC 9(6) COMP.
          05 MAX-NODES          PIC 9(6) COMP VALUE 1005.

       01 KD-NODES-DATA.
          05 NODES OCCURS 1005 TIMES.
             10 COORDS          COMP-2 OCCURS 3 TIMES.
             10 LEFT-CHILD      PIC 9(6) COMP.
             10 RIGHT-CHILD     PIC 9(6) COMP.

       01 KD-PTRS-DATA.
          05 PTRS OCCURS 1005 TIMES.
             10 NODE-PTR        PIC 9(6) COMP.

       01 TARGET-NODE-DATA.
          05 TARGET-COORDS      COMP-2 OCCURS 3 TIMES.

       01 I                     PIC 9(6) COMP.
       01 BEGIN-IDX             PIC 9(6) COMP.
       01 END-IDX               PIC 9(6) COMP.
       01 DIM-IDX               PIC 9(4) COMP.

       01 DISP-COORD-1          PIC -Z9.9(6).
       01 DISP-COORD-2          PIC -Z9.9(6).
       01 DISP-COORD-3          PIC -Z9.9(6).
       01 TMP-DIST              COMP-2.
       01 DISP-DIST             PIC -Z9.9(6).
       01 DISP-VISITED          PIC Z(5)9.

       01 L-POINTS              PIC 9(6) COMP.
       01 SEED                  PIC 9(9) COMP.
       01 DUMMY-FLOAT           COMP-2.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           MOVE FUNCTION CURRENT-DATE(11:6) TO SEED
           COMPUTE DUMMY-FLOAT = FUNCTION RANDOM(SEED)

           PERFORM TEST-WIKIPEDIA
           DISPLAY " "
           MOVE 100 TO L-POINTS
           PERFORM TEST-RANDOM
           DISPLAY " "
           MOVE 1000 TO L-POINTS
           PERFORM TEST-RANDOM

           STOP RUN.

       TEST-WIKIPEDIA.
           INITIALIZE KD-NODES-DATA
           MOVE 2 TO NUM-DIMENSIONS
           MOVE 6 TO TOTAL-NODES

           MOVE 0 TO TREE-ROOT
           MOVE 0 TO BEST-NODE
           MOVE 0 TO VISITED-COUNT

           MOVE 2 TO COORDS(1, 1)  MOVE 3 TO COORDS(1, 2)
           MOVE 5 TO COORDS(2, 1)  MOVE 4 TO COORDS(2, 2)
           MOVE 9 TO COORDS(3, 1)  MOVE 6 TO COORDS(3, 2)
           MOVE 4 TO COORDS(4, 1)  MOVE 7 TO COORDS(4, 2)
           MOVE 8 TO COORDS(5, 1)  MOVE 1 TO COORDS(5, 2)
           MOVE 7 TO COORDS(6, 1)  MOVE 2 TO COORDS(6, 2)

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 6
               MOVE I TO NODE-PTR OF PTRS(I)
           END-PERFORM

           MOVE 1 TO BEGIN-IDX
           MOVE 7 TO END-IDX
           MOVE 1 TO DIM-IDX
           CALL "MAKE-TREE" USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                  BEGIN-IDX END-IDX DIM-IDX TREE-ROOT

           MOVE 9 TO TARGET-COORDS(1)
           MOVE 2 TO TARGET-COORDS(2)
           MOVE 0 TO TARGET-COORDS(3)

           MOVE 1 TO DIM-IDX
           CALL "FIND-NEAREST" USING KD-TREE-STATE KD-NODES-DATA TARGET-NODE-DATA
                                     TREE-ROOT DIM-IDX

          *> DISPLAY "Tree dump:"
          *> PERFORM VARYING I FROM 1 BY 1 UNTIL I > 6
          *>   DISPLAY "Node " I ": (" FUNCTION TRIM(COORDS(I, 1)) ", " FUNCTION TRIM(COORDS(I, 2)) ") "
          *>           "L=" LEFT-CHILD(I) " R=" RIGHT-CHILD(I)
          *> END-PERFORM

           DISPLAY "Wikipedia example data:"
           COMPUTE TMP-DIST = FUNCTION SQRT(BEST-DISTANCE)
           MOVE COORDS(BEST-NODE, 1) TO DISP-COORD-1
           MOVE COORDS(BEST-NODE, 2) TO DISP-COORD-2
           DISPLAY "nearest point: (" FUNCTION TRIM(DISP-COORD-1) ", "
                                      FUNCTION TRIM(DISP-COORD-2) ")"
           MOVE TMP-DIST TO DISP-DIST
           DISPLAY "distance: " FUNCTION TRIM(DISP-DIST)
           MOVE VISITED-COUNT TO DISP-VISITED
           DISPLAY "nodes visited: " FUNCTION TRIM(DISP-VISITED).

       TEST-RANDOM.
           INITIALIZE KD-NODES-DATA
           MOVE 3 TO NUM-DIMENSIONS
           MOVE L-POINTS TO TOTAL-NODES

           MOVE 0 TO TREE-ROOT
           MOVE 0 TO BEST-NODE
           MOVE 0 TO VISITED-COUNT

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > L-POINTS
               COMPUTE COORDS(I, 1) = FUNCTION RANDOM
               COMPUTE COORDS(I, 2) = FUNCTION RANDOM
               COMPUTE COORDS(I, 3) = FUNCTION RANDOM
               MOVE I TO NODE-PTR OF PTRS(I)
           END-PERFORM

           MOVE 1 TO BEGIN-IDX
           COMPUTE END-IDX = L-POINTS + 1
           MOVE 1 TO DIM-IDX
           CALL "MAKE-TREE" USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                  BEGIN-IDX END-IDX DIM-IDX TREE-ROOT

           COMPUTE TARGET-COORDS(1) = FUNCTION RANDOM
           COMPUTE TARGET-COORDS(2) = FUNCTION RANDOM
           COMPUTE TARGET-COORDS(3) = FUNCTION RANDOM

           MOVE 1 TO DIM-IDX
           CALL "FIND-NEAREST" USING KD-TREE-STATE KD-NODES-DATA TARGET-NODE-DATA
                                     TREE-ROOT DIM-IDX

           DISPLAY "Random data (" L-POINTS " points):"
           MOVE TARGET-COORDS(1) TO DISP-COORD-1
           MOVE TARGET-COORDS(2) TO DISP-COORD-2
           MOVE TARGET-COORDS(3) TO DISP-COORD-3
           DISPLAY "target: (" FUNCTION TRIM(DISP-COORD-1) ", "
                               FUNCTION TRIM(DISP-COORD-2) ", "
                               FUNCTION TRIM(DISP-COORD-3) ")"

           COMPUTE TMP-DIST = FUNCTION SQRT(BEST-DISTANCE)
           MOVE COORDS(BEST-NODE, 1) TO DISP-COORD-1
           MOVE COORDS(BEST-NODE, 2) TO DISP-COORD-2
           MOVE COORDS(BEST-NODE, 3) TO DISP-COORD-3
           DISPLAY "nearest point: (" FUNCTION TRIM(DISP-COORD-1) ", "
                                      FUNCTION TRIM(DISP-COORD-2) ", "
                                      FUNCTION TRIM(DISP-COORD-3) ")"
           MOVE TMP-DIST TO DISP-DIST
           DISPLAY "distance: " FUNCTION TRIM(DISP-DIST)
           MOVE VISITED-COUNT TO DISP-VISITED
           DISPLAY "nodes visited: " FUNCTION TRIM(DISP-VISITED).

       END PROGRAM KD-TREE-TEST.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAKE-TREE IS RECURSIVE.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 QS-RIGHT              PIC 9(6) COMP.
       01 N-IDX                 PIC 9(6) COMP.
       01 NEXT-DIM              PIC 9(4) COMP.
       01 N-PLUS-1              PIC 9(6) COMP.

       LINKAGE SECTION.
       01 KD-TREE-STATE.
          05 NUM-DIMENSIONS     PIC 9(4) COMP.
          05 TOTAL-NODES        PIC 9(6) COMP.
          05 TREE-ROOT          PIC 9(6) COMP.
          05 BEST-NODE          PIC 9(6) COMP.
          05 BEST-DISTANCE      COMP-2.
          05 VISITED-COUNT      PIC 9(6) COMP.
          05 MAX-NODES          PIC 9(6) COMP.

       01 KD-NODES-DATA.
          05 NODES OCCURS 1005 TIMES.
             10 COORDS          COMP-2 OCCURS 3 TIMES.
             10 LEFT-CHILD      PIC 9(6) COMP.
             10 RIGHT-CHILD     PIC 9(6) COMP.

       01 KD-PTRS-DATA.
          05 PTRS OCCURS 1005 TIMES.
             10 NODE-PTR        PIC 9(6) COMP.

       01 BEGIN-IDX             PIC 9(6) COMP.
       01 END-IDX               PIC 9(6) COMP.
       01 DIM-IDX               PIC 9(4) COMP.
       01 RET-NODE              PIC 9(6) COMP.

       PROCEDURE DIVISION USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                BEGIN-IDX END-IDX DIM-IDX RET-NODE.
           IF END-IDX <= BEGIN-IDX
               MOVE 0 TO RET-NODE
               GOBACK
           END-IF

           COMPUTE N-IDX = BEGIN-IDX + (END-IDX - BEGIN-IDX) / 2
           COMPUTE QS-RIGHT = END-IDX - 1

           CALL "QUICK-SELECT" USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                     BEGIN-IDX QS-RIGHT N-IDX DIM-IDX RET-NODE

           COMPUTE NEXT-DIM = FUNCTION MOD(DIM-IDX, NUM-DIMENSIONS) + 1

           CALL "MAKE-TREE" USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                  BEGIN-IDX N-IDX NEXT-DIM LEFT-CHILD(RET-NODE)

           COMPUTE N-PLUS-1 = N-IDX + 1
           CALL "MAKE-TREE" USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                  N-PLUS-1 END-IDX NEXT-DIM RIGHT-CHILD(RET-NODE)

           GOBACK.
       END PROGRAM MAKE-TREE.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. QUICK-SELECT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 RANGE-SIZE            PIC 9(6) COMP.
       01 PIVOT                 PIC 9(6) COMP.
       01 PIVOT-VAL             PIC 9(6) COMP.
       01 TEMP                  PIC 9(6) COMP.
       01 STORE-IDX             PIC 9(6) COMP.
       01 I                     PIC 9(6) COMP.
       01 I-VAL                 PIC 9(6) COMP.
       01 RET-PIVOT             PIC 9(6) COMP.

       LINKAGE SECTION.
       01 KD-TREE-STATE.
          05 NUM-DIMENSIONS     PIC 9(4) COMP.
          05 TOTAL-NODES        PIC 9(6) COMP.
          05 TREE-ROOT          PIC 9(6) COMP.
          05 BEST-NODE          PIC 9(6) COMP.
          05 BEST-DISTANCE      COMP-2.
          05 VISITED-COUNT      PIC 9(6) COMP.
          05 MAX-NODES          PIC 9(6) COMP.

       01 KD-NODES-DATA.
          05 NODES OCCURS 1005 TIMES.
             10 COORDS          COMP-2 OCCURS 3 TIMES.
             10 LEFT-CHILD      PIC 9(6) COMP.
             10 RIGHT-CHILD     PIC 9(6) COMP.

       01 KD-PTRS-DATA.
          05 PTRS OCCURS 1005 TIMES.
             10 NODE-PTR        PIC 9(6) COMP.

       01 L-LEFT                PIC 9(6) COMP.
       01 L-RIGHT               PIC 9(6) COMP.
       01 L-N                   PIC 9(6) COMP.
       01 L-DIM                 PIC 9(4) COMP.
       01 L-RET                 PIC 9(6) COMP.

       PROCEDURE DIVISION USING KD-TREE-STATE KD-NODES-DATA KD-PTRS-DATA
                                L-LEFT L-RIGHT L-N L-DIM L-RET.
       MAIN-LOOP.
           PERFORM UNTIL 1 = 0
               IF L-LEFT = L-RIGHT
                   MOVE NODE-PTR OF PTRS(L-LEFT) TO L-RET
                   GOBACK
               END-IF

               COMPUTE RANGE-SIZE = L-RIGHT - L-LEFT + 1
               COMPUTE PIVOT = L-LEFT + FUNCTION INTEGER(RANGE-SIZE * FUNCTION RANDOM)
               IF PIVOT > L-RIGHT
                   MOVE L-RIGHT TO PIVOT
               END-IF

               MOVE NODE-PTR OF PTRS(PIVOT) TO PIVOT-VAL
               MOVE NODE-PTR OF PTRS(L-RIGHT) TO TEMP
               MOVE PIVOT-VAL TO NODE-PTR OF PTRS(L-RIGHT)
               MOVE TEMP TO NODE-PTR OF PTRS(PIVOT)
               MOVE L-LEFT TO STORE-IDX

               PERFORM VARYING I FROM L-LEFT BY 1 UNTIL I >= L-RIGHT
                   MOVE NODE-PTR OF PTRS(I) TO I-VAL
                   IF COORDS(I-VAL, L-DIM) < COORDS(PIVOT-VAL, L-DIM)
                       MOVE NODE-PTR OF PTRS(STORE-IDX) TO TEMP
                       MOVE I-VAL TO NODE-PTR OF PTRS(STORE-IDX)
                       MOVE TEMP TO NODE-PTR OF PTRS(I)
                       ADD 1 TO STORE-IDX
                   END-IF
               END-PERFORM

               MOVE NODE-PTR OF PTRS(STORE-IDX) TO TEMP
               MOVE NODE-PTR OF PTRS(L-RIGHT) TO NODE-PTR OF PTRS(STORE-IDX)
               MOVE TEMP TO NODE-PTR OF PTRS(L-RIGHT)
               MOVE STORE-IDX TO RET-PIVOT

               IF L-N = RET-PIVOT
                   MOVE NODE-PTR OF PTRS(L-N) TO L-RET
                   GOBACK
               ELSE
                   IF L-N < RET-PIVOT
                       COMPUTE L-RIGHT = RET-PIVOT - 1
                   ELSE
                       COMPUTE L-LEFT = RET-PIVOT + 1
                   END-IF
               END-IF
           END-PERFORM.
       END PROGRAM QUICK-SELECT.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIND-NEAREST IS RECURSIVE.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 I                     PIC 9(4) COMP.
       01 DIFF                  COMP-2.
       01 DIST-SQ               COMP-2.
       01 DX                    COMP-2.
       01 DX-SQ                 COMP-2.
       01 NEXT-DIM              PIC 9(4) COMP.
       01 FIRST-CHILD           PIC 9(6) COMP.
       01 SECOND-CHILD          PIC 9(6) COMP.

       LINKAGE SECTION.
       01 KD-TREE-STATE.
          05 NUM-DIMENSIONS     PIC 9(4) COMP.
          05 TOTAL-NODES        PIC 9(6) COMP.
          05 TREE-ROOT          PIC 9(6) COMP.
          05 BEST-NODE          PIC 9(6) COMP.
          05 BEST-DISTANCE      COMP-2.
          05 VISITED-COUNT      PIC 9(6) COMP.
          05 MAX-NODES          PIC 9(6) COMP.

       01 KD-NODES-DATA.
          05 NODES OCCURS 1005 TIMES.
             10 COORDS          COMP-2 OCCURS 3 TIMES.
             10 LEFT-CHILD      PIC 9(6) COMP.
             10 RIGHT-CHILD     PIC 9(6) COMP.

       01 TARGET-NODE-DATA.
          05 TARGET-COORDS      COMP-2 OCCURS 3 TIMES.

       01 L-CURR                PIC 9(6) COMP.
       01 L-DIM                 PIC 9(4) COMP.

       PROCEDURE DIVISION USING KD-TREE-STATE KD-NODES-DATA TARGET-NODE-DATA
                                L-CURR L-DIM.
           IF L-CURR = 0
               GOBACK
           END-IF

           ADD 1 TO VISITED-COUNT

           COMPUTE DIST-SQ = 0
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-DIMENSIONS
               COMPUTE DIFF = TARGET-COORDS(I) - COORDS(L-CURR, I)
               COMPUTE DIST-SQ = DIST-SQ + DIFF * DIFF
           END-PERFORM

           IF BEST-NODE = 0 OR DIST-SQ < BEST-DISTANCE
               MOVE DIST-SQ TO BEST-DISTANCE
               MOVE L-CURR TO BEST-NODE
           END-IF

           IF BEST-DISTANCE = 0
               GOBACK
           END-IF

           COMPUTE DX = COORDS(L-CURR, L-DIM) - TARGET-COORDS(L-DIM)

           COMPUTE NEXT-DIM = L-DIM + 1
           IF NEXT-DIM > NUM-DIMENSIONS
               MOVE 1 TO NEXT-DIM
           END-IF

           IF DX > 0
               MOVE LEFT-CHILD(L-CURR) TO FIRST-CHILD
               MOVE RIGHT-CHILD(L-CURR) TO SECOND-CHILD
           ELSE
               MOVE RIGHT-CHILD(L-CURR) TO FIRST-CHILD
               MOVE LEFT-CHILD(L-CURR) TO SECOND-CHILD
           END-IF

           CALL "FIND-NEAREST" USING KD-TREE-STATE KD-NODES-DATA TARGET-NODE-DATA
                                     FIRST-CHILD NEXT-DIM

           COMPUTE DX-SQ = DX * DX
           IF DX-SQ < BEST-DISTANCE
               CALL "FIND-NEAREST" USING KD-TREE-STATE KD-NODES-DATA TARGET-NODE-DATA
                                         SECOND-CHILD NEXT-DIM
           END-IF

           GOBACK.
       END PROGRAM FIND-NEAREST.
