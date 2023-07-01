      ******************************************************************
      * COBOL solution to Anagrams Deranged challange
      * The program was run on OpenCobolIDE
      * Input data is stored in file 'Anagrams.txt' on my PC
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DERANGED.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO 'C:\Both\Rosetta\Anagrams.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD IN-FILE.
       01 IN-RECORD                PIC X(22).

       WORKING-STORAGE SECTION.
       01  SWITCHES.
           05 WS-EOF               PIC X       VALUE 'N'.
           05 WS-FND               PIC X       VALUE 'N'.
           05 WS-EXIT              PIC X       VALUE 'N'.

       01 COUNTERS.
           05 WS-TOT-RECS          PIC 9(5)    COMP-3  VALUE 0.
           05 WS-SEL-RECS          PIC 9(5)    COMP-3  VALUE 0.
           05 WT-REC-NBR           PIC 9(5)    COMP-3  VALUE 0.

      * Extra byte to guarentee a space at end - needed in sort logic.
       01 WS-WORD-TEMP             PIC X(23).
       01 FILLER REDEFINES WS-WORD-TEMP.
           05   WS-LETTER  OCCURS 23 TIMES PIC X.
       77  WS-LETTER-HLD           PIC X.

       77  WS-WORD-IN              PIC X(22).
       77  WS-WORD-KEY             PIC X(22).

       01 WS-WORD-TABLE.
           05 WT-RECORD OCCURS 0 to 24000 TIMES
                   DEPENDING ON WT-REC-NBR
                   DESCENDING KEY IS WT-WORD-LEN
                   INDEXED BY WT-IDX.
               10 WT-WORD-KEY         PIC X(22).
               10 WT-WORD-LEN         PIC 9(2).
               10 WT-ANAGRAM-CNT      PIC 9(5) COMP-3.
               10 WT-ANAGRAMS OCCURS 6 TIMES.
                   15 WT-ANAGRAM      PIC X(22).

       01 WS-WORD-TEMP1             PIC X(22).
       01 FILLER REDEFINES WS-WORD-TEMP1.
           05   WS-LETTER1  OCCURS 22 TIMES PIC X.

       01 WS-WORD-TEMP2             PIC X(22).
       01 FILLER REDEFINES WS-WORD-TEMP2.
           05   WS-LETTER2  OCCURS 22 TIMES PIC X.

       77  WS-I                    PIC 99999  COMP-3.
       77  WS-J                    PIC 99999  COMP-3.
       77  WS-K                    PIC 99999  COMP-3.
       77  WS-L                    PIC 99999  COMP-3.
       77  WS-BEG                  PIC 99999  COMP-3.
       77  WS-MAX                  PIC 99999  COMP-3.

       PROCEDURE DIVISION.
       000-MAIN.
           PERFORM 100-INITIALIZE.
           PERFORM 200-PROCESS-RECORD
               UNTIL WS-EOF = 'Y'.
           SORT WT-RECORD ON DESCENDING KEY WT-WORD-LEN.
           PERFORM 500-FIND-DERANGED.
           PERFORM 900-TERMINATE.
           STOP RUN.

       100-INITIALIZE.
           OPEN INPUT IN-FILE.
           PERFORM 150-READ-RECORD.

       150-READ-RECORD.
           READ IN-FILE INTO WS-WORD-IN
               AT END
                   MOVE 'Y' TO WS-EOF
               NOT AT END
                   COMPUTE WS-TOT-RECS = WS-TOT-RECS + 1
           END-READ.

       200-PROCESS-RECORD.
           IF WS-WORD-IN IS ALPHABETIC
               COMPUTE WS-SEL-RECS = WS-SEL-RECS + 1
               MOVE WS-WORD-IN TO WS-WORD-TEMP
               PERFORM 300-SORT-WORD
               MOVE WS-WORD-TEMP TO WS-WORD-KEY
               PERFORM 400-ADD-TO-TABLE
           END-IF.

           PERFORM 150-READ-RECORD.

      * bubble sort:
       300-SORT-WORD.
           PERFORM VARYING WS-MAX FROM 1 BY 1
               UNTIL WS-LETTER(WS-MAX) = SPACE
           END-PERFORM.

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I = WS-MAX
               PERFORM VARYING WS-J FROM WS-I BY 1
                 UNTIL WS-J > WS-MAX - 1
                   IF WS-LETTER(WS-J) < WS-LETTER(WS-I) THEN
                       MOVE WS-LETTER(WS-I)  TO WS-LETTER-HLD
                       MOVE WS-LETTER(WS-J)  TO WS-LETTER(WS-I)
                       MOVE WS-LETTER-HLD    TO WS-LETTER(WS-J)
                   END-IF
               END-PERFORM
           END-PERFORM.

       400-ADD-TO-TABLE.
           SET WT-IDX TO 1.
           SEARCH WT-RECORD
               AT END
                   PERFORM 420-ADD-RECORD
               WHEN WT-WORD-KEY(WT-IDX) = WS-WORD-KEY
                   PERFORM 440-UPDATE-RECORD
           END-SEARCH.

       420-ADD-RECORD.
           ADD 1 To WT-REC-NBR.
           MOVE WS-WORD-KEY TO WT-WORD-KEY(WT-REC-NBR).
           COMPUTE WT-WORD-LEN(WT-REC-NBR) = WS-MAX - 1.
           MOVE 1 TO WT-ANAGRAM-CNT(WT-REC-NBR).
           MOVE WS-WORD-IN TO
               WT-ANAGRAM(WT-REC-NBR, WT-ANAGRAM-CNT(WT-REC-NBR)).

       440-UPDATE-RECORD.
           ADD 1 TO WT-ANAGRAM-CNT(WT-IDX).
           MOVE WS-WORD-IN TO
               WT-ANAGRAM(WT-IDX, WT-ANAGRAM-CNT(WT-IDX)).

       500-FIND-DERANGED.
           PERFORM VARYING WS-I FROM 1 BY 1
             UNTIL WS-I > WT-REC-NBR OR WS-FND = 'Y'
               PERFORM VARYING WS-J FROM 1 BY 1
                 UNTIL WS-J > WT-ANAGRAM-CNT(WS-I) - 1 OR WS-FND = 'Y'
                   COMPUTE WS-BEG = WS-J + 1
                   PERFORM VARYING WS-K FROM WS-BEG BY 1
                     UNTIL WS-K > WT-ANAGRAM-CNT(WS-I) OR WS-FND = 'Y'
                       MOVE WT-ANAGRAM(WS-I, WS-J) TO WS-WORD-TEMP1
                       MOVE WT-ANAGRAM(WS-I, WS-K) To WS-WORD-TEMP2
                       PERFORM 650-CHECK-DERANGED
                   END-PERFORM
               END-PERFORM
           END-PERFORM.

           650-CHECK-DERANGED.
               MOVE 'N' TO WS-EXIT.
               PERFORM VARYING WS-L FROM 1 BY 1
                   UNTIL WS-L > WT-WORD-LEN(WS-I) OR WS-EXIT = 'Y'
                       IF WS-LETTER1(WS-L) = WS-LETTER2(WS-L)
                           MOVE 'Y' TO WS-EXIT
               END-PERFORM.
               IF WS-EXIT = 'N'
                   DISPLAY WS-WORD-TEMP1(1:WT-WORD-LEN(WS-I))
                   ' '
                   WS-WORD-TEMP2
                   MOVE 'Y' TO WS-FND
               END-IF.

       900-TERMINATE.
           DISPLAY 'RECORDS READ: ' WS-TOT-RECS.
           DISPLAY 'RECORDS SELECTED ' WS-SEL-RECS.
           DISPLAY 'RECORD KEYS: ' WT-REC-NBR.
           CLOSE IN-FILE.

      *>   OUTPUT:

      *>      excitation intoxicate
      *>      RECORDS READ: 25104
      *>      RECORDS SELECTED 24978
      *>      RECORD KEYS: 23441

      *>   BUBBLE SORT REFERENCE:
      *>   https://mainframegeek.wordpress.com/tag/bubble-sort-in-cobol
