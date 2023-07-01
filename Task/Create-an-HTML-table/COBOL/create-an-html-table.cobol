       IDENTIFICATION DIVISION.
       PROGRAM-ID. Table.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  1 January 2022.
      ************************************************************
      ** Program Abstract:
      **   Data values are hardcoded in this example but they
      **     could come from anywhere.  Computed, read from a
      **     file, input from the keyboard.
      ************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT Table-File ASSIGN TO "index.html"
                 ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD  Table-File
           DATA RECORD IS Table-Record.
       01  Table-Record.
           05 Field1                  PIC X(80).

       WORKING-STORAGE SECTION.

       01  Table-Data.
           05  Line3.
               10  Line3-Value1  PIC S9(4)  VALUE  1234.
               10  Line3-Value2  PIC S9(4)  VALUE  23.
               10  Line3-Value3  PIC S9(4)  VALUE  -123.
           05  Line4.
               10  Line4-Value1  PIC S9(4)  VALUE  123.
               10  Line4-Value2  PIC S9(4)  VALUE  12.
               10  Line4-Value3  PIC S9(4)  VALUE  -1234.
           05  Line5.
               10  Line5-Value1  PIC S9(4)  VALUE  567.
               10  Line5-Value2  PIC S9(4)  VALUE  6789.
               10  Line5-Value3  PIC S9(4)  VALUE  3.


       01  Table-HTML.
           05  Line1  PIC X(16)  VALUE
               "<table border=1>".
           05  Line2  PIC X(40)  VALUE
               "<th></th><th>X</th><th>Y</th><th>Z</th>".
           05  Line3.
               10  Line3-Field1  PIC X(31)  VALUE
                   "<tr align=center><th>1</th><td>".
               10  Line3-Value1   PIC -ZZZ9.
               10  Line3-Field3  PIC X(9)  VALUE
                   "</td><td>".
               10  Line3-Value2   PIC -ZZZ9.
               10  Line3-Field5  PIC X(9)  VALUE
                   "</td><td>".
               10  Line3-Value3   PIC -ZZZ9.
               10  Line3-Field5  PIC X(10)  VALUE
                   "</td></tr>".
           05  Line4.
               10  Line4-Field1  PIC X(31)  VALUE
                   "<tr align=center><th>2</th><td>".
               10  Line4-Value1   PIC -ZZZ9.
               10  Line4-Field3  PIC X(9)  VALUE
                   "</td><td>".
               10  Line4-Value2   PIC -ZZZ9.
               10  Line4-Field5  PIC X(9)  VALUE
                   "</td><td>".
               10  Line4-Value3   PIC -ZZZ9.
               10  Line4-Field5  PIC X(10)  VALUE
                   "</td></tr>".
           05  Line5.
               10  Line5-Field1  PIC X(31)  VALUE
                   "<tr align=center><th>3</th><td>".
               10  Line5-Value1   PIC -ZZZ9.
               10  Line5-Field3  PIC X(9)  VALUE
                   "</td><td>".
               10  Line5-Value2   PIC -ZZZ9.
               10  Line5-Field5  PIC X(9)  VALUE
                   "</td><td>".
               10  Line5-Value3   PIC -ZZZ9.
               10  Line5-Field5  PIC X(10)  VALUE
                   "</td></tr>".
           05  Line6  PIC X(8)  VALUE
               "</table>".

       PROCEDURE DIVISION.

       Main-Program.
           OPEN OUTPUT Table-File.
           MOVE CORRESPONDING Table-Data TO Table-HTML.
           PERFORM Write-Table.
           CLOSE Table-File.
           STOP RUN.


       Write-Table.
           WRITE Table-Record FROM Line1 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.
           WRITE Table-Record FROM Line2 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.
           WRITE Table-Record FROM Line3 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.
           WRITE Table-Record FROM Line4 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.
           WRITE Table-Record FROM Line5 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.
           WRITE Table-Record FROM Line6 OF Table-HTML
                              AFTER  ADVANCING 1 LINE.


       END-PROGRAM.
