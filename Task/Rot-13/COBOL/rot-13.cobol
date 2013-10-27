       IDENTIFICATION DIVISION.
       PROGRAM-ID. rot-13.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       78  STR-LENGTH   VALUE 100.

       78  normal-lower VALUE "abcdefghijklmnopqrstuvwxyz".
       78  rot13-lower  VALUE "nopqrstuvwxyzabcdefghijklm".

       78  normal-upper VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       78  rot13-upper  VALUE "NOPQRSTUVWXYZABCDEFGHIJKLM".

       LINKAGE SECTION.
       01  in-str       PIC X(STR-LENGTH).
       01  out-str      PIC X(STR-LENGTH).

       PROCEDURE DIVISION USING VALUE in-str, REFERENCE out-str.
           MOVE in-str TO out-str

           INSPECT out-str CONVERTING normal-lower TO rot13-lower
           INSPECT out-str CONVERTING normal-upper TO rot13-upper

           GOBACK
           .
