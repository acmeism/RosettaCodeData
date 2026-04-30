       IDENTIFICATION DIVISION.
       PROGRAM-ID. Sleep-In-Seconds.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Seconds-To-Sleep       USAGE IS COMP-2.
      *>   Note: COMP-2, while supported on most implementations, is
      *>   non-standard. FLOAT-SHORT is the proper USAGE for Native
      *>   IEEE 754 Binary64 Floating-point data items.

       PROCEDURE DIVISION.
           ACCEPT Seconds-To-Sleep
           DISPLAY "Sleeping..."
           CALL "C$SLEEP" USING BY CONTENT Seconds-To-Sleep
           DISPLAY "Awake!"
           GOBACK.

       END PROGRAM Sleep-In-Seconds.
