       IDENTIFICATION DIVISION.
       PROGRAM-ID. MD5-DEMO.
       AUTHOR.  Bill Gunshannon
       INSTALLATION.  Home.
       DATE-WRITTEN.  16 December 2021.
      ************************************************************
      ** Program Abstract:
      **   Use the md5sum utility and pass the HASH back using
      **     a temp file.  Not elegant, but it works.
      **   Same program but made MD5 a User Defined Function
      **     instead of a procedure.
      ************************************************************


       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.

       REPOSITORY.
          FUNCTION MD5.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 Eof                   PIC X     VALUE 'F'.
       01 Str1.
          05  Pre-cmd   PIC X(8)
              VALUE 'echo -n '.
          05  Str1-complete.
              10  Str1-Part1  PIC X(26)
                  VALUE  'The quick brown fox jumps'.
              10  Str1-Part2  PIC X(19)
                  VALUE  ' over the lazy dog'.
          05  Post-cmd    PIC X(20)
              VALUE  ' | md5sum > /tmp/MD5'.
       01  Str1-MD5          PIC X(32).


       PROCEDURE DIVISION.

       Main-Program.

           DISPLAY Str1-complete.
      *    PERFORM Get-MD5.
           MOVE FUNCTION MD5(Str1) TO Str1-MD5.
           DISPLAY Str1-MD5.

           STOP RUN.

        END PROGRAM MD5-DEMO.

       IDENTIFICATION DIVISION.
       FUNCTION-ID. MD5.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT Tmp-MD5 ASSIGN TO "/tmp/MD5"
                 ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION.

       FILE SECTION.

       FD  Tmp-MD5
           DATA RECORD IS MD5-Rec.
       01  MD5-Rec       PIC X(32).



       LINKAGE SECTION.
       01  Str1        PIC X(128).
       01  Str1-MD5    PIC X(32).

       PROCEDURE DIVISION USING Str1 RETURNING Str1-MD5.

           CALL "SYSTEM" USING FUNCTION TRIM(Str1).
           OPEN INPUT Tmp-MD5.
           READ Tmp-MD5 INTO Str1-MD5.
           CLOSE Tmp-MD5.
           CALL "CBL_DELETE_FILE" USING '/tmp/MD5'.
           GO-BACK.

        END FUNCTION MD5.
