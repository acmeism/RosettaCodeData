       IDENTIFICATION DIVISION.
       PROGRAM-ID. TAU-FUNCTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TAU-VARS.
          03 TOTAL              PIC 999.
          03 N                  PIC 999.
          03 FILLER             REDEFINES N.
             05 FILLER          PIC 99.
             05 FILLER          PIC 9.
                88 N-EVEN       VALUES 0, 2, 4, 6, 8.
          03 P                  PIC 999.
          03 P-SQUARED          PIC 999.
          03 N-DIV-P            PIC 999V999.
          03 FILLER             REDEFINES N-DIV-P.
             05 NEXT-N          PIC 999.
             05 FILLER          PIC 999.
                88 DIVISIBLE    VALUE ZERO.
          03 F-COUNT            PIC 999.
       01 CONTROL-VARS.
          03 I                  PIC 999.
       01 OUT-VARS.
          03 OUT-ITM            PIC ZZ9.
          03 OUT-STR            PIC X(80) VALUE SPACES.
          03 OUT-PTR            PIC 99 VALUE 1.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SHOW-TAU VARYING I FROM 1 BY 1
               UNTIL I IS GREATER THAN 100.
           STOP RUN.

       SHOW-TAU.
           MOVE I TO N.
           PERFORM TAU.
           MOVE TOTAL TO OUT-ITM.
           STRING OUT-ITM DELIMITED BY SIZE INTO OUT-STR
               WITH POINTER OUT-PTR.
           IF OUT-PTR IS EQUAL TO 61,
               DISPLAY OUT-STR,
               MOVE 1 TO OUT-PTR.

       TAU.
           MOVE 1 TO TOTAL.
           PERFORM POWER-OF-2 UNTIL NOT N-EVEN.
           MOVE ZERO TO P-SQUARED.
           PERFORM ODD-FACTOR THRU ODD-FACTOR-LOOP
               VARYING P FROM 3 BY 2
               UNTIL P-SQUARED IS GREATER THAN N.
           IF N IS GREATER THAN 1,
               MULTIPLY 2 BY TOTAL.
       POWER-OF-2.
           ADD 1 TO TOTAL.
           DIVIDE 2 INTO N.
       ODD-FACTOR.
           MULTIPLY P BY P GIVING P-SQUARED.
           MOVE 1 TO F-COUNT.
       ODD-FACTOR-LOOP.
           DIVIDE N BY P GIVING N-DIV-P.
           IF DIVISIBLE,
               MOVE NEXT-N TO N,
               ADD 1 TO F-COUNT,
               GO TO ODD-FACTOR-LOOP.
           MULTIPLY F-COUNT BY TOTAL.
