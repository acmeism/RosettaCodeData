       IDENTIFICATION DIVISION.
       PROGRAM-ID. Delete-Files-2.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT Local-File ASSIGN TO "input.txt".
           SELECT Root-File  ASSIGN TO "/input.txt".

       DATA DIVISION.
       FILE SECTION.
       FD  Local-File.
       01  Local-Record PIC X.

       FD  Root-File.
       01  Root-Record  PIC X.

       PROCEDURE DIVISION.
           DELETE FILE Local-File
           DELETE FILE Root-File

           GOBACK
           .
