       IDENTIFICATION DIVISION.
       PROGRAM-ID. Sleep-In-Seconds.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Seconds-To-Sleep       USAGE IS FLOAT-LONG.

       PROCEDURE DIVISION.
           ACCEPT Seconds-To-Sleep
           DISPLAY "Sleeping..."
           CONTINUE AFTER Seconds-To-Sleep SECONDS
           DISPLAY "Awake!"
           GOBACK.

       END PROGRAM Sleep-In-Seconds.
