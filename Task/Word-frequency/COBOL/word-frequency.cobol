       IDENTIFICATION DIVISION.
       PROGRAM-ID. WordFrequency.
       AUTHOR.  Bill Gunshannon.
       DATE-WRITTEN.  30 Jan 2020.
      ************************************************************
      ** Program Abstract:
      **   Given a text file and an integer n, print the n most
      **   common words in the file (and the number of their
      **   occurrences) in decreasing frequency.
      **
      **   A file named Parameter.txt provides this information.
      **   Format is:
      **   12345678901234567890123456789012345678901234567890
      **   |------------------|----|
      **     ^^^^^^^^^^^^^^^^  ^^^^
      **          |              |
      **     Source Text File   Number of words with count
      **       20 Characters      5 digits with leading zeroes
      **
      **
      ************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT Parameter-File ASSIGN TO "Parameter.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Input-File ASSIGN TO Source-Text
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Word-File ASSIGN TO "Word.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Output-File ASSIGN TO "Output.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Print-File ASSIGN TO "Printer.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Sort-File     ASSIGN TO DISK.

       DATA DIVISION.

       FILE SECTION.

       FD  Parameter-File
           DATA RECORD IS Parameter-Record.
       01  Parameter-Record.
           05 Source-Text               PIC X(20).
           05 How-Many                  PIC 99999.

       FD  Input-File
           DATA RECORD IS Input-Record.
       01  Input-Record.
           05 Input-Line                PIC X(80).

       FD  Word-File
           DATA RECORD IS Word-Record.
       01  Word-Record.
           05 Input-Word               PIC X(20).

       FD  Output-File
           DATA RECORD IS Output-Rec.
       01  Output-Rec.
           05  Output-Rec-Word         PIC X(20).
           05  Output-Rec-Word-Cnt     PIC 9(5).

       FD  Print-File
           DATA RECORD IS Print-Rec.
       01  Print-Rec.
           05  Print-Rec-Word          PIC X(20).
           05  Print-Rec-Word-Cnt      PIC 9(5).

       SD  Sort-File.
       01  Sort-Rec.
           05  Sort-Word               PIC X(20).
           05  Sort-Word-Cnt           PIC 9(5).


       WORKING-STORAGE SECTION.

       01 Eof                    PIC X     VALUE 'F'.
       01 InLine                 PIC X(80).
       01 Word1                  PIC X(20).
       01 Current-Word           PIC X(20).
       01 Current-Word-Cnt       PIC 9(5).
       01 Pos                    PIC 99
                 VALUE 1.
       01 Cnt                    PIC 99.
       01 Report-Rank.
          05  IRank              PIC 99999
                 VALUE 1.
          05 Rank                PIC ZZZZ9.

       PROCEDURE DIVISION.

       Main-Program.
      **
      **  Read the Parameters
      **
         OPEN INPUT Parameter-File.
         READ Parameter-File.
         CLOSE Parameter-File.

      **
      **  Open Files for first stage
      **
         OPEN INPUT  Input-File.
         OPEN OUTPUT  Word-File.

      **
      **  Pare\se the Source Text into a file of invidual words
      **
         PERFORM UNTIL Eof = 'T'
            READ Input-File
               AT END MOVE 'T' TO Eof
            END-READ

         PERFORM Parse-a-Words

         MOVE SPACES TO Input-Record
         MOVE 1 TO Pos
         END-PERFORM.

      **
      **  Cleanup from the first stage
      **
         CLOSE Input-File Word-File

      **
      **  Sort the individual words in alphabetical order
      **
         SORT Sort-File
              ON ASCENDING KEY Sort-Word
              USING Word-File
              GIVING Word-File.

      **
      **  Count each time a word is used
      **
         PERFORM Collect-Totals.

      **
      **  Sort data by number of usages per word
      **
         SORT Sort-File
              ON DESCENDING KEY Sort-Word-Cnt
              USING Output-File
              GIVING Print-File.

      **
      **  Show the work done
      **
         OPEN INPUT Print-File.
            DISPLAY " Rank  Word               Frequency"
         PERFORM How-Many TIMES
            READ Print-File
            MOVE IRank TO Rank
            DISPLAY Rank "  " Print-Rec
            ADD 1 TO IRank
         END-PERFORM.

      **
      **  Cleanup
      **
         CLOSE Print-File.
         CALL "C$DELETE" USING "Word.txt" ,0
         CALL "C$DELETE" USING "Output.txt" ,0

         STOP RUN.


        Parse-a-Words.
          INSPECT Input-Record CONVERTING '-.,"();:/[]{}!?|' TO SPACE
          PERFORM UNTIL Pos > FUNCTION STORED-CHAR-LENGTH(Input-Record)


          UNSTRING Input-Record DELIMITED BY SPACE INTO Word1
                    WITH POINTER Pos TALLYING IN Cnt
          MOVE FUNCTION TRIM(FUNCTION LOWER-CASE(Word1)) TO Word-Record

          IF Word-Record NOT EQUAL SPACES AND Word-Record IS ALPHABETIC
             THEN WRITE Word-Record
          END-IF

          END-PERFORM.

       Collect-Totals.
          MOVE 'F' to Eof
          OPEN INPUT Word-File
          OPEN OUTPUT Output-File
             READ Word-File
             MOVE Input-Word TO Current-Word
             MOVE 1 to Current-Word-Cnt
          PERFORM UNTIL Eof = 'T'
             READ Word-File
                AT END MOVE 'T' TO Eof
             END-READ

             IF FUNCTION TRIM(Word-Record)
                    EQUAL
                           FUNCTION TRIM(Current-Word)
                THEN
                     ADD 1 to Current-Word-Cnt
                ELSE
                     MOVE Current-Word TO Output-Rec-Word
                     MOVE Current-Word-Cnt TO Output-Rec-Word-Cnt
                     WRITE Output-Rec
                     MOVE 1 to Current-Word-Cnt
                     MOVE Word-Record TO Current-Word
                     MOVE SPACES TO Input-Record
            END-IF

          END-PERFORM.
          CLOSE Word-File Output-File.
       END-PROGRAM.
