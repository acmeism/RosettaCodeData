       IDENTIFICATION DIVISION.
       PROGRAM-ID. bitwise-ops.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  a                       PIC 1(32) USAGE BIT.
       01  b                       PIC 1(32) USAGE BIT.
       01  result                  PIC 1(32) USAGE BIT.
       01  result-disp             REDEFINES result
                                   PIC S9(9) USAGE COMPUTATIONAL.
       LINKAGE SECTION.
       01  a-int                   USAGE BINARY-LONG.
       01  b-int                   USAGE BINARY-LONG.

       PROCEDURE DIVISION USING a-int, b-int.
           MOVE FUNCTION BOOLEAN-OF-INTEGER(a-int, 32) TO a
           MOVE FUNCTION BOOLEAN-OF-INTEGER(b-int, 32) TO b

           COMPUTE result = a B-AND b
           DISPLAY "a and b is " result-disp

           COMPUTE result = a B-OR b
           DISPLAY "a or b is " result-disp

           COMPUTE result = B-NOT a
           DISPLAY "Not a is " result-disp

           COMPUTE result = a B-XOR b
           DISPLAY "a exclusive-or b is " result-disp

      *>   More complex operations can be constructed from these.

           COMPUTE result = B-NOT (a B-XOR b)
           DISPLAY "Logical equivalence of a and b is " result-disp

           COMPUTE result = (B-NOT a) B-AND b
           DISPLAY "Logical implication of a and b is " result-disp

      *>   Shift and rotation operators were only added in COBOL 2023.

           COMPUTE result = a B-SHIFT-L b
           DISPLAY "a shifted left by b is " result-disp

           COMPUTE result = b B-SHIFT-R a
           DISPLAY "b shifted right by a is " result-disp

           COMPUTE result = a B-SHIFT-LC b
           DISPLAY "a rotated left by b is " result-disp

           COMPUTE result = b B-SHIFT-RC a
           DISPLAY "b rotated right by a is " result-disp

           GOBACK.

       END PROGRAM bitwise-ops.
