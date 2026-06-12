       IDENTIFICATION DIVISION.
       PROGRAM-ID. HeldKarpAlgorithm.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 N                PIC 9(4) COMP VALUE 4.
       01 SUBSET-COUNT     PIC 9(4) COMP VALUE 16.
       01 INFINITY         PIC 9(9) COMP VALUE 536870912.

       01 DISTANCES-TABLE.
           05 D-ROW OCCURS 4 TIMES.
               10 D-COL OCCURS 4 TIMES.
                   15 DIST PIC 9(4) COMP.

       01 DP-TABLE.
           05 DP-ROW OCCURS 16 TIMES.
               10 DP-COL OCCURS 4 TIMES.
                   15 DP-VAL PIC 9(9) COMP.

       01 PARENTS-TABLE.
           05 PAR-ROW OCCURS 16 TIMES.
               10 PAR-COL OCCURS 4 TIMES.
                   15 PAR-VAL PIC S9(4) COMP.

       01 MASK          PIC 9(4) COMP.
       01 MASK-PLUS-1   PIC 9(4) COMP.
       01 PREV-MASK     PIC 9(4) COMP.
       01 PREV-PLUS-1   PIC 9(4) COMP.
       01 J-IDX         PIC 9(4) COMP.
       01 K-IDX         PIC 9(4) COMP.
       01 J-PLUS-1      PIC 9(4) COMP.
       01 K-PLUS-1      PIC 9(4) COMP.
       01 COST          PIC 9(9) COMP.
       01 FULL-MASK     PIC 9(4) COMP.
       01 MIN-COST      PIC 9(9) COMP.
       01 LAST-CITY     PIC 9(4) COMP.
       01 CURR-CITY     PIC 9(4) COMP.
       01 PAR-CITY      PIC S9(4) COMP.

       01 TOUR-TABLE.
           05 TOUR-CITY OCCURS 20 TIMES.
               10 T-CITY PIC 9(4) COMP.
       01 TOUR-LEN      PIC 9(4) COMP VALUE 0.
       01 IDX           PIC S9(4) COMP.

       01 DISPLAY-MIN-COST PIC Z(8)9.
       01 DISPLAY-CITY     PIC 9.
       01 TEMP-DIV      PIC 9(4) COMP.
       01 TEMP-MOD      PIC 9(4) COMP.

       01 TWO-POW-TABLE.
           05 TWO-POW OCCURS 16 TIMES PIC 9(4) COMP.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INIT-DISTANCES.
           PERFORM INIT-TWO-POW.
           PERFORM INIT-DP.

           MOVE 0 TO DP-VAL(2, 1).

           PERFORM VARYING MASK FROM 1 BY 1
                 UNTIL MASK = SUBSET-COUNT
             COMPUTE MASK-PLUS-1 = MASK + 1
             COMPUTE TEMP-MOD = FUNCTION MOD(MASK, 2)
             IF TEMP-MOD NOT = 0
               PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX = N
                 COMPUTE J-PLUS-1 = J-IDX + 1
                 DIVIDE TWO-POW(J-PLUS-1) INTO MASK
                       GIVING TEMP-DIV
                 COMPUTE TEMP-MOD = FUNCTION MOD(TEMP-DIV, 2)
                 IF TEMP-MOD NOT = 0
                   COMPUTE PREV-MASK = MASK - TWO-POW(J-PLUS-1)
                   COMPUTE PREV-PLUS-1 = PREV-MASK + 1
                   PERFORM VARYING K-IDX FROM 0 BY 1
                         UNTIL K-IDX = N
                     COMPUTE K-PLUS-1 = K-IDX + 1
                     DIVIDE TWO-POW(K-PLUS-1) INTO PREV-MASK
                           GIVING TEMP-DIV
                     COMPUTE TEMP-MOD = FUNCTION MOD(TEMP-DIV, 2)
                     IF TEMP-MOD NOT = 0
                       COMPUTE COST = DP-VAL(PREV-PLUS-1, K-PLUS-1)
                                      + DIST(K-PLUS-1, J-PLUS-1)
                       IF COST < DP-VAL(MASK-PLUS-1, J-PLUS-1)
                         MOVE COST TO DP-VAL(MASK-PLUS-1, J-PLUS-1)
                         MOVE K-IDX TO PAR-VAL(MASK-PLUS-1, J-PLUS-1)
                       END-IF
                     END-IF
                   END-PERFORM
                 END-IF
               END-PERFORM
             END-IF
           END-PERFORM.

           COMPUTE FULL-MASK = SUBSET-COUNT - 1.
           MOVE INFINITY TO MIN-COST.
           MOVE 0 TO LAST-CITY.
           COMPUTE MASK-PLUS-1 = FULL-MASK + 1.

           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX = N
               COMPUTE J-PLUS-1 = J-IDX + 1
               COMPUTE COST = DP-VAL(MASK-PLUS-1, J-PLUS-1) +
                   DIST(J-PLUS-1, 1)
               IF COST < MIN-COST
                   MOVE COST TO MIN-COST
                   MOVE J-IDX TO LAST-CITY
               END-IF
           END-PERFORM.

           MOVE MIN-COST TO DISPLAY-MIN-COST.
           DISPLAY "Minimum tour cost: "
               FUNCTION TRIM(DISPLAY-MIN-COST).

           MOVE FULL-MASK TO PREV-MASK.
           MOVE LAST-CITY TO CURR-CITY.
           COMPUTE TOUR-LEN = 0.

           PERFORM UNTIL CURR-CITY = 0
               COMPUTE TOUR-LEN = TOUR-LEN + 1
               MOVE CURR-CITY TO T-CITY(TOUR-LEN)
               COMPUTE PREV-PLUS-1 = PREV-MASK + 1
               COMPUTE J-PLUS-1 = CURR-CITY + 1
               MOVE PAR-VAL(PREV-PLUS-1, J-PLUS-1) TO PAR-CITY
               COMPUTE PREV-MASK = PREV-MASK - TWO-POW(J-PLUS-1)
               MOVE PAR-CITY TO CURR-CITY
           END-PERFORM.

           COMPUTE TOUR-LEN = TOUR-LEN + 1.
           MOVE 0 TO T-CITY(TOUR-LEN).

           DISPLAY "Tour: [" WITH NO ADVANCING.
           PERFORM VARYING IDX FROM TOUR-LEN BY -1 UNTIL IDX < 1
               MOVE T-CITY(IDX) TO DISPLAY-CITY
               IF IDX > 1
                   DISPLAY DISPLAY-CITY ", " WITH NO ADVANCING
               ELSE
                   DISPLAY DISPLAY-CITY ", 0]"
               END-IF
           END-PERFORM.

           STOP RUN.

       INIT-DISTANCES.
           MOVE 0 TO DIST(1, 1). MOVE 2 TO DIST(1, 2).
           MOVE 9 TO DIST(1, 3). MOVE 10 TO DIST(1, 4).
           MOVE 1 TO DIST(2, 1). MOVE 0 TO DIST(2, 2).
           MOVE 6 TO DIST(2, 3). MOVE 4 TO DIST(2, 4).
           MOVE 15 TO DIST(3, 1). MOVE 7 TO DIST(3, 2).
           MOVE 0 TO DIST(3, 3). MOVE 8 TO DIST(3, 4).
           MOVE 6 TO DIST(4, 1). MOVE 3 TO DIST(4, 2).
           MOVE 12 TO DIST(4, 3). MOVE 0 TO DIST(4, 4).
           EXIT.

       INIT-TWO-POW.
           MOVE 1 TO TWO-POW(1). MOVE 2 TO TWO-POW(2).
           MOVE 4 TO TWO-POW(3). MOVE 8 TO TWO-POW(4).
           MOVE 16 TO TWO-POW(5). MOVE 32 TO TWO-POW(6).
           MOVE 64 TO TWO-POW(7). MOVE 128 TO TWO-POW(8).
           MOVE 256 TO TWO-POW(9). MOVE 512 TO TWO-POW(10).
           MOVE 1024 TO TWO-POW(11). MOVE 2048 TO TWO-POW(12).
           MOVE 4096 TO TWO-POW(13). MOVE 8192 TO TWO-POW(14).
           MOVE 16384 TO TWO-POW(15). MOVE 32768 TO TWO-POW(16).
           EXIT.

       INIT-DP.
           PERFORM VARYING MASK FROM 1 BY 1 UNTIL MASK > 16
               PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > 4
                   MOVE INFINITY TO DP-VAL(MASK, J-IDX)
                   MOVE -1 TO PAR-VAL(MASK, J-IDX)
               END-PERFORM
           END-PERFORM.
           EXIT.

