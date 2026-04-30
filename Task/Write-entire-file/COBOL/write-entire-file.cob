       IDENTIFICATION DIVISION.
       PROGRAM-ID. Overwrite.
       AUTHOR. Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  31 December 2021.
      ************************************************************
      ** Program Abstract:
      **   Simple COBOL task.  Open file for output.  Write
      **     data to file. Close file.  Done...
      ************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT File-Name ASSIGN TO "File.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.

       FILE SECTION.

       FD  File-Name
           DATA RECORD IS Record-Name.
       01  Record-Name.
           02 Field1                  PIC X(80).

       WORKING-STORAGE SECTION.

       01 New-Val                   PIC X(80)
              VALUE 'Hello World'.


       PROCEDURE DIVISION.

       Main-Program.
           OPEN OUTPUT File-Name.
           WRITE Record-Name FROM New-Val.
           CLOSE File-Name.
           STOP RUN.

       END-PROGRAM.
