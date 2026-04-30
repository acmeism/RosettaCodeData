       IDENTIFICATION DIVISION.
       PROGRAM-ID. Sleep-In-Nanoseconds.
       OPTIONS.
           DEFAULT ROUNDED MODE IS NEAREST-AWAY-FROM-ZERO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Seconds-To-Sleep       USAGE IS FLOAT-LONG.
       01  Nanoseconds-To-Sleep   USAGE IS FLOAT-LONG.
       01  Nanoseconds-Per-Second CONSTANT AS 1000000000.

       PROCEDURE DIVISION.
           ACCEPT Seconds-To-Sleep
           COMPUTE Nanoseconds-To-Sleep
               = Seconds-To-Sleep * Nanoseconds-Per-Second
           END-COMPUTE

           DISPLAY "Sleeping..."
           CALL "CBL_OC_NANOSLEEP"
               USING BY CONTENT Nanoseconds-To-Sleep
           END-CALL

           DISPLAY "Awake!"
           GOBACK.

       END PROGRAM Sleep-In-Nanoseconds.
