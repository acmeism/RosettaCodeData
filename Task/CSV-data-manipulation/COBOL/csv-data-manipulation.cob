       IDENTIFICATION DIVISION.
       PROGRAM-ID. CSV.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  19 December 2021.
      ************************************************************
      ** Program Abstract:
      **   CSVs are something COBOL does pretty well.
      **     The commented out CONCATENATE statements are a
      **     second method other than the STRING method.
      ************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
           REPOSITORY.
           FUNCTION ALL INTRINSIC.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT CSV-File ASSIGN TO "csv.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
            SELECT Out-File ASSIGN TO "new.csv.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION.

       FILE SECTION.

       FD  CSV-File
           DATA RECORD IS CSV-Record.
       01  CSV-Record.
           05 Field1                  PIC X(64).

       FD  Out-File
           DATA RECORD IS Out-Line.
       01  Out-Line   PIC X(80).

       WORKING-STORAGE SECTION.

       01 Eof                   PIC X     VALUE 'F'.

       01  CSV-Data.
           05  CSV-Col1             PIC 9(5).
           05  CSV-Col2             PIC 9(5).
           05  CSV-Col3             PIC 9(5).
           05  CSV-Col4             PIC 9(5).
           05  CSV-Col5             PIC 9(5).

        01  CSV-Sum                  PIC ZZZ9.
        01  CSV-Sum-Alpha
                REDEFINES     CSV-Sum  PIC X(4).

       PROCEDURE DIVISION.

       Main-Program.
           OPEN INPUT  CSV-File
           OPEN OUTPUT Out-File
           PERFORM Read-a-Record
           PERFORM Build-Header
           PERFORM UNTIL Eof = 'T'
              PERFORM Read-a-Record
              IF Eof NOT EQUAL 'T' PERFORM Process-a-Record
           END-PERFORM
           CLOSE CSV-File
           CLOSE Out-File
           STOP RUN.

       Read-a-Record.
           READ CSV-File
              AT END MOVE 'T' TO Eof
           END-READ.

        Build-Header.
      **    MOVE CONCATENATE(TRIM(CSV-Record), ",SUM"
      **        TO Out-Line.
            STRING TRIM(CSV-Record), ",SUM" INTO Out-Line.
            WRITE Out-Line.
            MOVE SPACES TO Out-Line.

        Process-a-Record.
            UNSTRING CSV-Record DELIMITED BY ',' INTO
                  CSV-Col1 CSV-Col2 CSV-Col3 CSV-Col4 CSV-Col5.
            COMPUTE CSV-Sum =
                  CSV-Col1 + CSV-Col2 + CSV-Col3 + CSV-Col4 + CSV-Col5.
      **    MOVE CONCATENATE(TRIM(CSV-Record), "," TRIM(CSV-Sum-Alpha))
      **        TO Out-Line.
            STRING TRIM(CSV-Record), "," TRIM(CSV-Sum-Alpha)
                   INTO Out-Line.
            WRITE Out-Line.
            MOVE SPACES TO Out-Line.

       END-PROGRAM.
