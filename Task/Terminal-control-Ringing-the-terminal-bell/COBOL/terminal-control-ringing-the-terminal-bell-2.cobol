      *> Tectonics: cobc -xj ring-terminal-bell.cob -std=cobol85
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ring-ascii-bell.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       OBJECT-COMPUTER.
           PROGRAM COLLATING SEQUENCE IS ASCII.
       SPECIAL-NAMES.
           ALPHABET ASCII IS STANDARD-1.

       PROCEDURE DIVISION.
           DISPLAY FUNCTION CHAR(8) WITH NO ADVANCING
           STOP RUN.

       END PROGRAM ring-ascii-bell.
