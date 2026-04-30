IDENTIFICATION DIVISION.
       PROGRAM-ID. FLOYD-WARSHALL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-NUM-VERTICES        PIC 9 VALUE 4.
       01  WS-NUM-WEIGHTS         PIC 9 VALUE 5.
       01  WS-INFINITY            PIC 9(7)V9(2) VALUE 9999999.99.

       01  WS-WEIGHTS.
           05 WS-W OCCURS 5 TIMES.
              10 WS-FROM          PIC 9.
              10 WS-TO            PIC 9.
              10 WS-COST          PIC S9(3) SIGN LEADING SEPARATE.

       01  WS-DIST.
           05 WS-D OCCURS 4 TIMES.
              10 WS-D-COL OCCURS 4 TIMES.
                 15 WS-DIST-VAL   PIC S9(7)V9(2).

       01  WS-NEXT.
           05 WS-N OCCURS 4 TIMES.
              10 WS-N-COL OCCURS 4 TIMES.
                 15 WS-NEXT-VAL   PIC 9.

       01  WS-I                   PIC 9.
       01  WS-J                   PIC 9.
       01  WS-K                   PIC 9.
       01  WS-U                   PIC 9.
       01  WS-V                   PIC 9.
       01  WS-IDX                 PIC 9.
       01  WS-TEMP-SUM            PIC S9(7)V9(2).
       01  WS-DIST-IJ             PIC S9(7)V9(2).
       01  WS-DIST-IK             PIC S9(7)V9(2).
       01  WS-DIST-KJ             PIC S9(7)V9(2).

      *> Path and display working fields
       01  WS-PATH                PIC X(200).
       01  WS-PATH-TEMP           PIC X(200).
       01  WS-DIST-INT            PIC S9(5).
       01  WS-DIST-EDIT           PIC -(4)9.
       01  WS-DIST-TRIM           PIC X(6).
       01  WS-OUTPUT-LINE         PIC X(80).
       01  WS-NODE-CHAR           PIC 9.

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE 1  TO WS-FROM(1)
           MOVE 3  TO WS-TO(1)
           MOVE -2 TO WS-COST(1)

           MOVE 2  TO WS-FROM(2)
           MOVE 1  TO WS-TO(2)
           MOVE 4  TO WS-COST(2)

           MOVE 2  TO WS-FROM(3)
           MOVE 3  TO WS-TO(3)
           MOVE 3  TO WS-COST(3)

           MOVE 3  TO WS-FROM(4)
           MOVE 4  TO WS-TO(4)
           MOVE 2  TO WS-COST(4)

           MOVE 4  TO WS-FROM(5)
           MOVE 2  TO WS-TO(5)
           MOVE -1 TO WS-COST(5)

           PERFORM INIT-DIST
           PERFORM INIT-NEXT
           PERFORM FLOYD-WARSHALL
           PERFORM PRINT-RESULT
           STOP RUN.

       INIT-DIST.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-NUM-VERTICES
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-NUM-VERTICES
                   MOVE WS-INFINITY TO WS-DIST-VAL(WS-I, WS-J)
               END-PERFORM
           END-PERFORM
           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-NUM-WEIGHTS
               MOVE WS-FROM(WS-IDX) TO WS-I
               MOVE WS-TO(WS-IDX)   TO WS-J
               MOVE WS-COST(WS-IDX) TO WS-DIST-VAL(WS-I, WS-J)
           END-PERFORM.

       INIT-NEXT.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-NUM-VERTICES
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-NUM-VERTICES
                   IF WS-I NOT EQUAL WS-J
                       MOVE WS-J TO WS-NEXT-VAL(WS-I, WS-J)
                   ELSE
                       MOVE 0 TO WS-NEXT-VAL(WS-I, WS-J)
                   END-IF
               END-PERFORM
           END-PERFORM.

       FLOYD-WARSHALL.
           PERFORM VARYING WS-K FROM 1 BY 1
               UNTIL WS-K > WS-NUM-VERTICES
               PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > WS-NUM-VERTICES
                   PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > WS-NUM-VERTICES
                       MOVE WS-DIST-VAL(WS-I, WS-K) TO WS-DIST-IK
                       MOVE WS-DIST-VAL(WS-K, WS-J) TO WS-DIST-KJ
                       MOVE WS-DIST-VAL(WS-I, WS-J) TO WS-DIST-IJ
                       IF WS-DIST-IK < WS-INFINITY AND
                          WS-DIST-KJ < WS-INFINITY
                           COMPUTE WS-TEMP-SUM =
                               WS-DIST-IK + WS-DIST-KJ
                           IF WS-TEMP-SUM < WS-DIST-IJ
                               MOVE WS-TEMP-SUM
                                   TO WS-DIST-VAL(WS-I, WS-J)
                               MOVE WS-NEXT-VAL(WS-I, WS-K)
                                   TO WS-NEXT-VAL(WS-I, WS-J)
                           END-IF
                       END-IF
                   END-PERFORM
               END-PERFORM
           END-PERFORM.

       PRINT-RESULT.
           DISPLAY "pair     dist    path"
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-NUM-VERTICES
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J > WS-NUM-VERTICES
                   IF WS-I NOT EQUAL WS-J

      *>                Set up source and destination
                       MOVE WS-I TO WS-U
                       MOVE WS-J TO WS-V

      *>                Seed path with just the source node
                       MOVE SPACES TO WS-PATH
                       MOVE WS-I TO WS-NODE-CHAR
                       MOVE WS-NODE-CHAR TO WS-PATH(1:1)

      *>                Walk next-hop until we reach destination
                       PERFORM UNTIL WS-U = WS-V
                           MOVE WS-NEXT-VAL(WS-U, WS-V) TO WS-U
                           MOVE WS-U TO WS-NODE-CHAR
                           MOVE SPACES TO WS-PATH-TEMP
                           STRING
                               FUNCTION TRIM(WS-PATH TRAILING)
                                             DELIMITED SIZE
                               " -> "        DELIMITED SIZE
                               WS-NODE-CHAR  DELIMITED SIZE
                           INTO WS-PATH-TEMP
                           MOVE WS-PATH-TEMP TO WS-PATH
                       END-PERFORM

      *>                Format distance: move to integer then edit picture
      *>                to get clean signed number without leading zeros
                       COMPUTE WS-DIST-INT =
                           WS-DIST-VAL(WS-I, WS-J)
                       MOVE WS-DIST-INT TO WS-DIST-EDIT
                       MOVE FUNCTION TRIM(WS-DIST-EDIT LEADING)
                           TO WS-DIST-TRIM

      *>                Assemble and print output line
                       MOVE SPACES TO WS-OUTPUT-LINE
                       STRING
                           WS-I          DELIMITED SIZE
                           " -> "        DELIMITED SIZE
                           WS-J          DELIMITED SIZE
                           "    "        DELIMITED SIZE
                           FUNCTION TRIM(WS-DIST-TRIM LEADING)
                                         DELIMITED SIZE
                           "     "       DELIMITED SIZE
                           FUNCTION TRIM(WS-PATH TRAILING)
                                         DELIMITED SIZE
                       INTO WS-OUTPUT-LINE
                       DISPLAY FUNCTION TRIM(WS-OUTPUT-LINE TRAILING)
                   END-IF
               END-PERFORM
           END-PERFORM.
