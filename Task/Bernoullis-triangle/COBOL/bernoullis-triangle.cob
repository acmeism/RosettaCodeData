 IDENTIFICATION DIVISION.
 PROGRAM-ID. BERNOULLIS-TRIANGLE.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01  WS-N                        PIC 99 VALUE 0.
 01  WS-K                        PIC 99 VALUE 0.
 01  WS-IDX                      PIC 99 VALUE 0.

 01  WS-PREV-ROW.
     05  WS-PREV-ELEM            PIC 9(10) OCCURS 15 TIMES.
 01  WS-CURR-ROW.
     05  WS-CURR-ELEM            PIC 9(10) OCCURS 15 TIMES.

 01  WS-FORMATTED                PIC Z(9)9.

 PROCEDURE DIVISION.
 MAIN-PARA.
     PERFORM VARYING WS-N FROM 0 BY 1
         UNTIL WS-N > 14

         INITIALIZE WS-CURR-ROW

         PERFORM VARYING WS-K FROM 0 BY 1
             UNTIL WS-K > WS-N

             EVALUATE TRUE
                 WHEN WS-K = 0
                     MOVE 1
                         TO WS-CURR-ELEM(WS-K + 1)

                 WHEN WS-K < WS-N
                     ADD WS-PREV-ELEM(WS-K + 1)
                         WS-PREV-ELEM(WS-K)
                         GIVING WS-CURR-ELEM(WS-K + 1)

                 WHEN OTHER
                     MULTIPLY 2 BY WS-PREV-ELEM(WS-N)
                         GIVING WS-CURR-ELEM(WS-K + 1)
             END-EVALUATE

         END-PERFORM

         PERFORM DISPLAY-ROW

         MOVE WS-CURR-ROW TO WS-PREV-ROW

     END-PERFORM

     STOP RUN
     .

 DISPLAY-ROW.
     PERFORM VARYING WS-IDX FROM 1 BY 1
         UNTIL WS-IDX > WS-N + 1

         MOVE WS-CURR-ELEM(WS-IDX) TO WS-FORMATTED
         DISPLAY WS-FORMATTED WITH NO ADVANCING
         DISPLAY " " WITH NO ADVANCING

     END-PERFORM

     DISPLAY SPACE
     .

