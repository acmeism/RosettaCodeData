       IDENTIFICATION DIVISION.
       PROGRAM-ID. mf-bell.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  bell-code              PIC X USAGE COMP-X VALUE 22.
       01  dummy-param            PIC X.

       PROCEDURE DIVISION.
           CALL X"AF" USING bell-code, dummy-param

           GOBACK
           .
