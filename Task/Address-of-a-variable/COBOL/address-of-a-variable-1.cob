       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 ptr USAGE POINTER.
       01 var PIC X(64).

       PROCEDURE DIVISION.
           SET ptr TO ADDRESS OF var.
