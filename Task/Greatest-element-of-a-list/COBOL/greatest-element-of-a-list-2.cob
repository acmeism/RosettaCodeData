       IDENTIFICATION DIVISION.
       FUNCTION-ID. greatest-elt.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  idx                     USAGE INDEX.

       01  Table-Len               CONSTANT 50.

       LINKAGE SECTION.
       01  num-table-area.
           03  num-table           PIC 9(8) OCCURS Table-Len TIMES.

       01  max-elt                 PIC 9(8).

       PROCEDURE DIVISION USING VALUE num-table-area RETURNING max-elt.
           PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > Table-Len
               IF num-table (idx) > max-elt
                   MOVE num-table (idx) TO max-elt
               END-IF
           END-PERFORM

           GOBACK
           .
       END FUNCTION greatest-elt.
