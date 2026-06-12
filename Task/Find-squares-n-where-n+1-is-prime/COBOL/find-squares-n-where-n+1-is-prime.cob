       IDENTIFICATION DIVISION.
       PROGRAM-ID. SQUARE-PLUS-1-PRIME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 N                   PIC 999.
       01 P                   PIC 9999 VALUE ZERO.
       01 PRIMETEST.
          03 DSOR             PIC 9999.
          03 PRIME-FLAG       PIC X.
             88 PRIME         VALUE '*'.
          03 DIVTEST          PIC 9999V999.
          03 FILLER           REDEFINES DIVTEST.
             05 FILLER        PIC 9999.
             05 FILLER        PIC 999.
                88 DIVISIBLE  VALUE ZERO.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CHECK-N VARYING N FROM 1 BY 1
                UNTIL P IS GREATER THAN 1000.
           STOP RUN.

       CHECK-N.
           MULTIPLY N BY N GIVING P.
           ADD 1 TO P.
           PERFORM CHECK-PRIME.
           SUBTRACT 1 FROM P.
           IF PRIME, DISPLAY P.

       CHECK-PRIME.
           IF P IS LESS THAN 2, MOVE SPACE TO PRIME-FLAG,
           ELSE, MOVE '*' TO PRIME-FLAG.
           PERFORM CHECK-DSOR VARYING DSOR FROM 2 BY 1
               UNTIL NOT PRIME OR DSOR IS GREATER THAN N.

       CHECK-DSOR.
           DIVIDE P BY DSOR GIVING DIVTEST.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
