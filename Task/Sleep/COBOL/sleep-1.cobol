       IDENTIFICATION DIVISION.
       PROGRAM-ID. Sleep-In-Seconds.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Seconds-To-Sleep       USAGE COMP-2.

       PROCEDURE DIVISION.
           ACCEPT Seconds-To-Sleep

           DISPLAY "Sleeping..."

           CALL "C$SLEEP" USING BY CONTENT Seconds-To-Sleep

           DISPLAY "Awake!"

           GOBACK
           .
