       IDENTIFICATION DIVISION.
       PROGRAM-ID. Twos_complement.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 d PIC S9(7) COMP-5 VALUE 1234567.
       01 neg-d PIC S9(7) COMP-5.
       01 neg-d1 PIC S9(7) COMP-5.
       01 neg-b PIC S9(7) COMP-5.
       01 d2 PIC S9(7) COMP-5.
       01 d1 PIC S9(7) COMP-5.
       01 b OCCURS 9 TIMES PIC S9(7) COMP-5.
       01 i PIC 9(2) VALUE 1.
       PROCEDURE DIVISION.
           COMPUTE neg-d = -d
           COMPUTE neg-d1 = -d + 1
           COMPUTE d2 = d - 2
           COMPUTE d1 = d - 1
           MOVE neg-d TO b(1)
           MOVE neg-d1 TO b(2)
           MOVE -2 TO b(3)
           MOVE -1 TO b(4)
           MOVE 0 TO b(5)
           MOVE 1 TO b(6)
           MOVE 2 TO b(7)
           MOVE d2 TO b(8)
           MOVE d1 TO b(9)
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > 9
               COMPUTE neg-b = -b(i)
               DISPLAY b(i) " -> " neg-b
           END-PERFORM
           STOP RUN.
