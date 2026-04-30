       IDENTIFICATION DIVISION.
       PROGRAM-ID. ABC-PROBLEM.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 INPUT-DATA.
          03 BLOCK-SET          PIC X(40) VALUE
                        'BOXKDQCPNAGTRETGQDFSJWHUVIANOBERFSLYPCZM'.
          03 WORD-DATA.
             05 FILLER          PIC X(7) VALUE 'A'.
             05 FILLER          PIC X(7) VALUE 'BARK'.
             05 FILLER          PIC X(7) VALUE 'BOOK'.
             05 FILLER          PIC X(7) VALUE 'TREAT'.
             05 FILLER          PIC X(7) VALUE 'COMMON'.
             05 FILLER          PIC X(7) VALUE 'SQUAD'.
             05 FILLER          PIC X(7) VALUE 'CONFUSE'.
          03 WORDS              PIC X(7) OCCURS 7 TIMES, INDEXED BY W,
                                REDEFINES WORD-DATA.

       01 OUTPUT-LINE.
          03 OUT-WORD           PIC X(7).
          03 FILLER             PIC XX VALUE ': '.
          03 RESULT             PIC X(3).
          03 FOO                PIC 999.

       01 VARIABLES.
          03 BLOCK-SET          PIC X(40).
          03 BLOCKS             OCCURS 20 TIMES, INDEXED BY B,
                                REDEFINES BLOCK-SET.
             05 FACE-A          PIC X.
             05 FACE-B          PIC X.
          03 WORD.
             05 LETTERS         PIC X OCCURS 7 TIMES, INDEXED BY L.
          03 FAIL-FLAG          PIC X.
             88 FAILED          VALUE 'X'.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM CHECK-WORD VARYING W FROM 1 BY 1
           UNTIL W IS GREATER THAN 7.
           STOP RUN.

       CHECK-WORD.
           MOVE BLOCK-SET OF INPUT-DATA TO BLOCK-SET OF VARIABLES.

           MOVE WORDS(W) TO WORD.
           SET L TO 1.
           MOVE SPACE TO FAIL-FLAG.
           PERFORM CHECK-LETTER VARYING L FROM 1 BY 1
               UNTIL FAILED
               OR L IS GREATER THAN 7
               OR LETTERS(L) IS EQUAL TO SPACE.

           MOVE WORDS(W) TO OUT-WORD.
           IF FAILED, MOVE 'NO' TO RESULT, ELSE MOVE 'YES' TO RESULT.
           DISPLAY OUTPUT-LINE.

       CHECK-LETTER.
           SET B TO 1.
           SEARCH BLOCKS VARYING B
               AT END
                   MOVE 'X' TO FAIL-FLAG
               WHEN LETTERS(L) IS EQUAL TO FACE-A(B) OR FACE-B(B)
                   MOVE SPACES TO BLOCKS(B).
