       IDENTIFICATION DIVISION.
       PROGRAM-ID. mf-bitwise-ops.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  result                  USAGE BINARY-LONG.
       78  arg-len                 VALUE LENGTH OF result.

       LINKAGE SECTION.
       01  a                       USAGE BINARY-LONG.
       01  b                       USAGE BINARY-LONG.

       PROCEDURE DIVISION USING a, b.
       main-line.
           MOVE b TO result
           CALL "CBL_AND" USING a, result, VALUE arg-len
           DISPLAY "a and b is " result

           MOVE b TO result
           CALL "CBL_OR" USING a, result, VALUE arg-len
           DISPLAY "a or b is " result

           MOVE a TO result
           CALL "CBL_NOT" USING result, VALUE arg-len
           DISPLAY "Not a is " result

           MOVE b TO result
           CALL "CBL_XOR" USING a, result, VALUE arg-len
           DISPLAY "a exclusive-or b is " result

           MOVE b TO result
           CALL "CBL_EQ" USING a, result, VALUE arg-len
           DISPLAY "Logical equivalence of a and b is " result

           MOVE b TO result
           CALL "CBL_IMP" USING a, result, VALUE arg-len
           DISPLAY "Logical implication of a and b is " result

           GOBACK.

       END PROGRAM mf-bitwise-ops.
