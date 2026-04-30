OCOBOL*> Rosetta Code set address example
      *> tectonics: cobc -x setaddr.cob && ./setaddr
       IDENTIFICATION DIVISION.
       PROGRAM-ID. setaddr.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 prealloc PIC X(8) VALUE 'somedata'.
       01 var      PIC X(8) BASED.

       PROCEDURE DIVISION.
           SET ADDRESS OF var TO ADDRESS OF prealloc
           DISPLAY var END-DISPLAY
      *>    'somedata'
           GOBACK.

       END PROGRAM setaddr.
