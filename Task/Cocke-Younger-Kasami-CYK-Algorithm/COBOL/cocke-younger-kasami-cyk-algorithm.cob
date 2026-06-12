       IDENTIFICATION DIVISION.
       PROGRAM-ID. CYKParser.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  N PIC 9 VALUE 5.
       01  W-ARRAY.
           05 W OCCURS 5 TIMES PIC X(15).

       01  I PIC 9.
       01  J PIC 9.
       01  K PIC 9.
       01  K-PLUS-1 PIC 9.

       01  T-TABLE.
           05 T-COL OCCURS 5 TIMES.
               10 T-ROW OCCURS 5 TIMES.
                   15 HAS-NP  PIC 9 VALUE 0.
                   15 HAS-NOM PIC 9 VALUE 0.
                   15 HAS-DET PIC 9 VALUE 0.
                   15 HAS-AP  PIC 9 VALUE 0.
                   15 HAS-ADV PIC 9 VALUE 0.
                   15 HAS-A   PIC 9 VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           MOVE "a"          TO W(1).
           MOVE "very"       TO W(2).
           MOVE "heavy"      TO W(3).
           MOVE "orange"     TO W(4).
           MOVE "book"       TO W(5).

           PERFORM VARYING J FROM 1 BY 1 UNTIL J > N
               EVALUATE FUNCTION TRIM(W(J))
                   WHEN "book"
                       MOVE 1 TO HAS-NOM(J, J)
                   WHEN "orange"
                       MOVE 1 TO HAS-NOM(J, J)
                       MOVE 1 TO HAS-AP(J, J)
                       MOVE 1 TO HAS-A(J, J)
                   WHEN "man"
                       MOVE 1 TO HAS-NOM(J, J)
                   WHEN "heavy"
                       MOVE 1 TO HAS-AP(J, J)
                       MOVE 1 TO HAS-A(J, J)
                   WHEN "tall"
                       MOVE 1 TO HAS-AP(J, J)
                       MOVE 1 TO HAS-A(J, J)
                   WHEN "a"
                       MOVE 1 TO HAS-DET(J, J)
                   WHEN "very"
                       MOVE 1 TO HAS-ADV(J, J)
                   WHEN "extremely"
                       MOVE 1 TO HAS-ADV(J, J)
                   WHEN "muscular"
                       MOVE 1 TO HAS-A(J, J)
               END-EVALUATE

               PERFORM VARYING I FROM J BY -1 UNTIL I < 1
                   PERFORM VARYING K FROM I BY 1 UNTIL K > J - 1
                       COMPUTE K-PLUS-1 = K + 1

                       IF HAS-DET(I, K) = 1 AND HAS-NOM(K-PLUS-1, J) = 1
                           MOVE 1 TO HAS-NP(I, J)
                       END-IF

                       IF HAS-AP(I, K) = 1 AND HAS-NOM(K-PLUS-1, J) = 1
                           MOVE 1 TO HAS-NOM(I, J)
                       END-IF

                       IF HAS-ADV(I, K) = 1 AND HAS-A(K-PLUS-1, J) = 1
                           MOVE 1 TO HAS-AP(I, J)
                       END-IF
                   END-PERFORM
               END-PERFORM
           END-PERFORM.

           IF HAS-NP(1, N) = 1
               DISPLAY "True"
           ELSE
               DISPLAY "False"
           END-IF.

           STOP RUN.

