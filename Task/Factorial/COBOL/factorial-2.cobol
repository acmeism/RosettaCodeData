       IDENTIFICATION DIVISION.
       FUNCTION-ID. factorial_iterative.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  i      PIC 9(38).

       LINKAGE SECTION.
       01  n      PIC 9(38).
       01  ret    PIC 9(38).

       PROCEDURE DIVISION USING BY VALUE n RETURNING ret.
           MOVE 1 TO ret

           PERFORM VARYING i FROM 2 BY 1 UNTIL n < i
               MULTIPLY i BY ret
           END-PERFORM

           GOBACK.

       END FUNCTION factorial_iterative.
