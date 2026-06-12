       IDENTIFICATION DIVISION.
       PROGRAM-ID. PALINDROMIC-BASE-2-4-16.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          02 CUR-NUM           PIC 9(5).
          02 REV-BASE          PIC 99.
          02 REV-REST          PIC 9(5).
          02 REV-NEXT          PIC 9(5).
          02 REV-DGT           PIC 99.
          02 REVERSED          PIC 9(5).

       01 OUTPUT-FORMAT.
          02 OUT-NUM           PIC Z(4)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM 2-4-16-PALINDROME
               VARYING CUR-NUM FROM ZERO BY 1
               UNTIL CUR-NUM IS NOT LESS THAN 25000.
           STOP RUN.

       2-4-16-PALINDROME.
           MOVE 16 TO REV-BASE, PERFORM REVERSE THRU REV-LOOP
           IF CUR-NUM IS EQUAL TO REVERSED
               MOVE 4 TO REV-BASE, PERFORM REVERSE THRU REV-LOOP
               IF CUR-NUM IS EQUAL TO REVERSED
                   MOVE 2 TO REV-BASE, PERFORM REVERSE THRU REV-LOOP
                   IF CUR-NUM IS EQUAL TO REVERSED
                       MOVE CUR-NUM TO OUT-NUM
                       DISPLAY OUT-NUM.

       REVERSE.
           MOVE ZERO TO REVERSED.
           MOVE CUR-NUM TO REV-REST.
       REV-LOOP.
           IF REV-REST IS GREATER THAN ZERO
               DIVIDE REV-BASE INTO REV-REST GIVING REV-NEXT
               COMPUTE REV-DGT = REV-REST - REV-NEXT * REV-BASE
               MULTIPLY REV-BASE BY REVERSED
               ADD REV-DGT TO REVERSED
               MOVE REV-NEXT TO REV-REST
               GO TO REV-LOOP.
