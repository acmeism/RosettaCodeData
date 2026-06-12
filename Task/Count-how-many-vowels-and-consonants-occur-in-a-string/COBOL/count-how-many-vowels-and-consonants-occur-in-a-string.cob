       IDENTIFICATION DIVISION.
       PROGRAM-ID. VOWELS-AND-CONSONANTS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CONSTANTS.
          03 LETTERS-DAT.
             05 FILLER      PIC X(5) VALUE "AEIOU".
             05 FILLER      PIC X(5) VALUE "aeiou".
             05 FILLER      PIC X(21) VALUE "BCDFGHJKLMNPQRSTVWXYZ".
             05 FILLER      PIC X(21) VALUE "bcdfghjklmnpqrstvwxyz".
          03 LETTERS        REDEFINES LETTERS-DAT.
             05 VOWELS      PIC X OCCURS 10 TIMES INDEXED BY V.
             05 CONSONANTS  PIC X OCCURS 42 TIMES INDEXED BY C.

       01 VARIABLES.
          03 IN-STR         PIC X(80).
          03 N-VOWELS       PIC 99.
          03 N-CONSONANTS   PIC 99.

       01 REPORT.
          03 R-VOWELS       PIC Z9.
          03 FILLER         PIC X(9) VALUE " vowels, ".
          03 R-CONSONANTS   PIC Z9.
          03 FILLER         PIC X(12) VALUE " consonants.".

       PROCEDURE DIVISION.
       BEGIN.
           MOVE "If not now, then when? If not us, then who?"
           TO IN-STR.
           PERFORM COUNT-AND-SHOW.
           STOP RUN.

       COUNT-AND-SHOW.
           DISPLAY IN-STR.
           PERFORM COUNT-VOWELS-AND-CONSONANTS.
           MOVE N-VOWELS TO R-VOWELS.
           MOVE N-CONSONANTS TO R-CONSONANTS.
           DISPLAY REPORT.

       COUNT-VOWELS-AND-CONSONANTS.
           MOVE ZERO TO N-VOWELS, N-CONSONANTS.
           SET V TO 1.
           PERFORM COUNT-VOWEL 10 TIMES.
           SET C TO 1.
           PERFORM COUNT-CONSONANT 42 TIMES.

       COUNT-VOWEL.
           INSPECT IN-STR TALLYING N-VOWELS FOR ALL VOWELS(V).
           SET V UP BY 1.

       COUNT-CONSONANT.
           INSPECT IN-STR TALLYING N-CONSONANTS FOR ALL CONSONANTS(C).
           SET C UP BY 1.
