       IDENTIFICATION DIVISION.
       PROGRAM-ID. ALL-VOWELS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT DICT ASSIGN TO DISK
           ORGANIZATION LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD DICT
           LABEL RECORD STANDARD
           VALUE OF FILE-ID IS "unixdict.txt".
       01 WORD            PIC X(64).

       WORKING-STORAGE SECTION.
       01 A               PIC 99.
       01 E               PIC 99.
       01 I               PIC 99.
       01 O               PIC 99.
       01 U               PIC 99.
       01 LEN             PIC 99.

       PROCEDURE DIVISION.
       BEGIN.
           OPEN INPUT DICT.

       READ-WORD.
           READ DICT, AT END CLOSE DICT, STOP RUN.
           PERFORM CHECK-WORD.
           GO TO READ-WORD.

       CHECK-WORD.
           MOVE ZERO TO LEN, A, E, I, O, U.
           INSPECT WORD TALLYING LEN FOR CHARACTERS
               BEFORE INITIAL SPACE.
           INSPECT WORD TALLYING A FOR ALL 'a'.
           INSPECT WORD TALLYING E FOR ALL 'e'.
           INSPECT WORD TALLYING I FOR ALL 'i'.
           INSPECT WORD TALLYING O FOR ALL 'o'.
           INSPECT WORD TALLYING U FOR ALL 'u'.
           IF LEN IS GREATER THAN 10
              AND 1 IS EQUAL TO A AND E AND I AND O AND U,
               DISPLAY WORD.
