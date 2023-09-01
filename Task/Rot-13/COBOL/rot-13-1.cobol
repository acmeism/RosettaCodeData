FORMAT IDENTIFICATION DIVISION.
       PROGRAM-ID. rot-13.

       DATA DIVISION.
       LINKAGE SECTION.
       77  in-str       PIC X(100).
       77  out-str      PIC X(100).

       PROCEDURE DIVISION USING BY REFERENCE in-str, out-str.
           MOVE in-str TO out-str
           INSPECT out-str
               CONVERTING "abcdefghijklmnopqrstuvwxyz"
               TO "nopqrstuvwxyzabcdefghijklm"
           INSPECT out-str
               CONVERTING "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
               TO "NOPQRSTUVWXYZABCDEFGHIJKLM"
           EXIT PROGRAM.

       END PROGRAM rot-13.
