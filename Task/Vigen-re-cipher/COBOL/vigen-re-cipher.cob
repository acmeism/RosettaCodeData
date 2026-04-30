IDENTIFICATION DIVISION.
       PROGRAM-ID. VIGENERE-CIPHER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-VARIABLES.
           05 WS-KEY          PIC X(14) VALUE "VIGENERECIPHER".
           05 WS-KEY-LEN      PIC 9(3)  VALUE 14.

           *> Group definition to safely handle long string literal
           05 WS-ORI-DEF.
              10 FILLER PIC X(35) VALUE "Beware the Jabberwock, my son! The ".
              10 FILLER PIC X(37) VALUE "jaws that bite, the claws that catch!".
           05 WS-ORI REDEFINES WS-ORI-DEF PIC X(72).
           05 WS-ORI-LEN      PIC 9(3)  VALUE 72.

           05 WS-TEXT-UPPER   PIC X(100).
           05 WS-ENC          PIC X(100).
           05 WS-ENC-LEN      PIC 9(3)  VALUE 0.
           05 WS-DEC          PIC X(100).
           05 WS-DEC-LEN      PIC 9(3)  VALUE 0.
           05 ALPHABET-STR    PIC X(26) VALUE
              "ABCDEFGHIJKLMNOPQRSTUVWXYZ".

       01  WS-COUNTERS.
           05 I               PIC S9(4) COMP.
           05 J               PIC S9(4) COMP.
           05 C-VAL           PIC S9(4) COMP.
           05 K-VAL           PIC S9(4) COMP.
           05 TEMP-VAL        PIC S9(4) COMP.
           05 RES-POS         PIC S9(4) COMP.
           05 TEXT-CHAR       PIC X(1).
           05 KEY-CHAR        PIC X(1).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           *> Java: text.toUpperCase()
           MOVE FUNCTION UPPER-CASE(WS-ORI) TO WS-TEXT-UPPER

           PERFORM ENCRYPT-ROUTINE
           IF WS-ENC-LEN > 0
               DISPLAY WS-ENC(1:WS-ENC-LEN)
           ELSE
               DISPLAY " "
           END-IF

           PERFORM DECRYPT-ROUTINE
           IF WS-DEC-LEN > 0
               DISPLAY WS-DEC(1:WS-DEC-LEN)
           ELSE
               DISPLAY " "
           END-IF

           STOP RUN.

       ENCRYPT-ROUTINE.
           MOVE SPACES TO WS-ENC
           MOVE 0 TO WS-ENC-LEN
           MOVE 1 TO J

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-ORI-LEN
               MOVE WS-TEXT-UPPER(I:1) TO TEXT-CHAR
               MOVE 0 TO C-VAL

               *> Find position of char (0 for A, 25 for Z, 26 if not found)
               INSPECT ALPHABET-STR TALLYING C-VAL
                   FOR CHARACTERS BEFORE INITIAL TEXT-CHAR

               *> Simulates Java's `if (c < 'A' || c > 'Z') continue;`
               IF C-VAL < 26 THEN
                   MOVE WS-KEY(J:1) TO KEY-CHAR
                   MOVE 0 TO K-VAL
                   INSPECT ALPHABET-STR TALLYING K-VAL
                       FOR CHARACTERS BEFORE INITIAL KEY-CHAR

                   *> Math: (C-VAL + K-VAL) % 26
                   COMPUTE TEMP-VAL = C-VAL + K-VAL
                   COMPUTE TEMP-VAL = FUNCTION MOD(TEMP-VAL, 26)

                   *> Convert back to 1-based index for COBOL strings
                   COMPUTE RES-POS = TEMP-VAL + 1

                   ADD 1 TO WS-ENC-LEN
                   MOVE ALPHABET-STR(RES-POS:1)
                     TO WS-ENC(WS-ENC-LEN:1)

                   *> Java: j = ++j % key.length()
                   ADD 1 TO J
                   IF J > WS-KEY-LEN THEN
                       MOVE 1 TO J
                   END-IF
               END-IF
           END-PERFORM.

       DECRYPT-ROUTINE.
           MOVE SPACES TO WS-DEC
           MOVE 0 TO WS-DEC-LEN
           MOVE 1 TO J

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-ENC-LEN
               MOVE WS-ENC(I:1) TO TEXT-CHAR
               MOVE 0 TO C-VAL
               INSPECT ALPHABET-STR TALLYING C-VAL
                   FOR CHARACTERS BEFORE INITIAL TEXT-CHAR

               IF C-VAL < 26 THEN
                   MOVE WS-KEY(J:1) TO KEY-CHAR
                   MOVE 0 TO K-VAL
                   INSPECT ALPHABET-STR TALLYING K-VAL
                       FOR CHARACTERS BEFORE INITIAL KEY-CHAR

                   *> Math: (C-VAL - K-VAL + 26) % 26
                   COMPUTE TEMP-VAL = C-VAL - K-VAL + 26
                   COMPUTE TEMP-VAL = FUNCTION MOD(TEMP-VAL, 26)
                   COMPUTE RES-POS = TEMP-VAL + 1

                   ADD 1 TO WS-DEC-LEN
                   MOVE ALPHABET-STR(RES-POS:1)
                     TO WS-DEC(WS-DEC-LEN:1)

                   ADD 1 TO J
                   IF J > WS-KEY-LEN THEN
                       MOVE 1 TO J
                   END-IF
               END-IF
           END-PERFORM.
