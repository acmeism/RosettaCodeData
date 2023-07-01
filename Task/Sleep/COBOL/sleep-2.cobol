       IDENTIFICATION DIVISION.
       PROGRAM-ID. Sleep-In-Nanoseconds.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Seconds-To-Sleep       USAGE COMP-2.
       01  Nanoseconds-To-Sleep   USAGE COMP-2.
       01  Nanoseconds-Per-Second CONSTANT 1000000000.

       PROCEDURE DIVISION.
           ACCEPT Seconds-To-Sleep
           MULTIPLY Seconds-To-Sleep BY Nanoseconds-Per-Second
               GIVING Nanoseconds-To-Sleep

           DISPLAY "Sleeping..."

           CALL "CBL_OC_NANOSLEEP"
               USING BY CONTENT Nanoseconds-To-Sleep

           DISPLAY "Awake!"

           GOBACK
           .
