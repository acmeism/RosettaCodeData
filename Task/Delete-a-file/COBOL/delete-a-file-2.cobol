       IDENTIFICATION DIVISION.
       PROGRAM-ID. Delete-Files.

       PROCEDURE DIVISION.
           CALL "CBL_DELETE_FILE" USING "input.txt"
           CALL "CBL_DELETE_DIR"  USING "docs"
           CALL "CBL_DELETE_FILE" USING "/input.txt"
           CALL "CBL_DELETE_DIR"  USING "/docs"

           GOBACK.

       END PROGRAM Delete-Files.
