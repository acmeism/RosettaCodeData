       IDENTIFICATION DIVISION.
       PROGRAM-ID. TheGameName.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 nombre PIC X(20).
       01 x PIC X(20).
       01 x0 PIC X(1).
       01 y PIC X(20).
       01 b PIC X(20).
       01 f PIC X(20).
       01 m PIC X(20).
       01 i PIC 9(2) VALUE 1.
       01 listanombres OCCURS 6 TIMES PIC X(20).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           MOVE "Gary" TO listanombres(1)
           MOVE "EARL" TO listanombres(2)
           MOVE "billy" TO listanombres(3)
           MOVE "FeLiX" TO listanombres(4)
           MOVE "Mary" TO listanombres(5)
           MOVE "ShirlEY" TO listanombres(6)

           PERFORM VARYING i FROM 1 BY 1 UNTIL i > 6
               MOVE listanombres(i) TO nombre
               PERFORM TheGameName
           END-PERFORM
           STOP RUN.

       TheGameName.
           MOVE FUNCTION LOWER-CASE(nombre) TO x
           MOVE FUNCTION UPPER-CASE(x(1:1)) TO x0
           STRING x0 DELIMITED BY SIZE
               x(2:) DELIMITED BY SIZE INTO x

           IF x0 = "A" OR x0 = "E" OR x0 = "I" OR x0 = "O" OR x0 = "U"
               MOVE FUNCTION LOWER-CASE(x) TO y
           ELSE
               MOVE x(2:) TO y
           END-IF

           STRING "b" y DELIMITED BY SIZE INTO b
           STRING "f" y DELIMITED BY SIZE INTO f
           STRING "m" y DELIMITED BY SIZE INTO m

           IF x0 = "B"
               MOVE y TO b
           ELSE IF x0 = "F"
               MOVE y TO f
           ELSE IF x0 = "M"
               MOVE y TO m
           END-IF

           DISPLAY x ", " x ", bo-" b
           DISPLAY "Banana-fana fo-" f
           DISPLAY "Fee-fi-mo-" m
           DISPLAY x "!".
