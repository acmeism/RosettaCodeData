       IDENTIFICATION DIVISION.
       FUNCTION-ID. perfect.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  max-val                 PIC 9(8).
       01  total                   PIC 9(8) VALUE 1.
       01  i                       PIC 9(8).
       01  q                       PIC 9(8).

       LINKAGE SECTION.
       01  n                       PIC 9(8).
       01  is-perfect              PIC 9.

       PROCEDURE DIVISION USING VALUE n RETURNING is-perfect.
           COMPUTE max-val = FUNCTION INTEGER(FUNCTION SQRT(n)) + 1

           PERFORM VARYING i FROM 2 BY 1 UNTIL i = max-val
               IF FUNCTION MOD(n, i) = 0
                   ADD i TO total

                   DIVIDE n BY i GIVING q
                   IF q > i
                       ADD q TO total
                   END-IF
               END-IF
           END-PERFORM

           IF total = n
               MOVE 0 TO is-perfect
           ELSE
               MOVE 1 TO is-perfect
           END-IF

           GOBACK
           .
       END FUNCTION perfect.
