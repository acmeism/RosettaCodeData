       IDENTIFICATION DIVISION.
       PROGRAM-ID. MTF-ENCODE-DECODE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> Initial alphabet reference
       01  ALPHABET-INIT       PIC X(26) VALUE
                               "abcdefghijklmnopqrstuvwxyz".

       *> Dynamic character list (simulates the JS charList array)
       01  CHAR-TABLE.
           05 CHAR-ITEM        PIC X OCCURS 26 TIMES.

       *> Variables for processing
       01  WORK-AREAS.
           05 INPUT-WORD       PIC X(20) VALUE SPACES.
           05 WORD-LEN         PIC 99 VALUE 0.
           05 I                PIC 99 VALUE 0.
           05 J                PIC 99 VALUE 0.
           05 K                PIC 99 VALUE 0.
           05 TEMP-CHAR        PIC X VALUE SPACE.
           05 CHAR-INDEX       PIC 99 VALUE 0.

       *> Storage for algorithm outputs
       01  ENCODED-DATA.
           05 ENCODED-NUMBERS  PIC 99 OCCURS 20 TIMES.
       01  DECODED-DATA.
           05 DECODED-WORD     PIC X(20) VALUE SPACES.

       *> Variables for console logging/displaying
       01  DISPLAY-AREAS.
           05 DISPLAY-LINE     PIC X(120) VALUE SPACES.
           05 DISP-POS         PIC 99 VALUE 1.
           05 DISP-NUM         PIC Z9.

       *> Equivalent to JS: var words = ['broood', ...]
       01  TEST-DATA.
           05 TEST-WORDS.
              10 FILLER        PIC X(20) VALUE "broood".
              10 FILLER        PIC X(20) VALUE "bananaaa".
              10 FILLER        PIC X(20) VALUE "hiphophiphop".
           05 TEST-WORD-REDEF REDEFINES TEST-WORDS.
              10 TEST-WORD-ARR PIC X(20) OCCURS 3 TIMES.
           05 TEST-IDX         PIC 9 VALUE 1.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           DISPLAY "Testing Move-To-Front (MTF) Algorithm".
           DISPLAY "=====================================".

           *> Equivalent to: words.map(...)
           PERFORM VARYING TEST-IDX FROM 1 BY 1 UNTIL TEST-IDX > 3
               MOVE TEST-WORD-ARR(TEST-IDX) TO INPUT-WORD
               PERFORM GET-WORD-LENGTH

               DISPLAY "Original Word : " INPUT-WORD(1:WORD-LEN)

               *> Encode
               PERFORM ENCODE-MTF
               PERFORM PRINT-ENCODED

               *> Decode
               PERFORM DECODE-MTF
               PERFORM PRINT-DECODED

               DISPLAY "-------------------------------------"
           END-PERFORM.

           STOP RUN.

       *> ==========================================
       *> ENCODE ALGORITHM
       *> ==========================================
       ENCODE-MTF.
           PERFORM INIT-CHAR-LIST.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WORD-LEN
               MOVE INPUT-WORD(I:1) TO TEMP-CHAR
               MOVE 0 TO CHAR-INDEX

               *> Simulate JS: charList.indexOf(char)
               PERFORM VARYING J FROM 1 BY 1
                                 UNTIL J > 26 OR CHAR-INDEX > 0
                   IF CHAR-ITEM(J) = TEMP-CHAR
                       MOVE J TO CHAR-INDEX
                   END-IF
               END-PERFORM

               *> JS arrays are 0-indexed, COBOL is 1-indexed.
               *> Subtract 1 to match exact JS numeric output.
               COMPUTE ENCODED-NUMBERS(I) = CHAR-INDEX - 1

               *> Simulate JS: splice(charNum, 1) and unshift()
               PERFORM MOVE-TO-FRONT
           END-PERFORM.

       *> ==========================================
       *> DECODE ALGORITHM
       *> ==========================================
       DECODE-MTF.
           PERFORM INIT-CHAR-LIST.
           MOVE SPACES TO DECODED-WORD.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WORD-LEN
               *> Convert JS 0-based index back to COBOL 1-based index
               COMPUTE CHAR-INDEX = ENCODED-NUMBERS(I) + 1
               MOVE CHAR-ITEM(CHAR-INDEX) TO TEMP-CHAR

               *> Append character to decoded string
               MOVE TEMP-CHAR TO DECODED-WORD(I:1)

               *> Simulate JS: splice(num, 1) and unshift()
               PERFORM MOVE-TO-FRONT
           END-PERFORM.

       *> ==========================================
       *> SHARED HELPER FUNCTIONS
       *> ==========================================

       *> Moves item at CHAR-INDEX to position 1, shifting rest right
       MOVE-TO-FRONT.
           IF CHAR-INDEX > 1
               PERFORM VARYING K FROM CHAR-INDEX BY -1 UNTIL K = 1
                   COMPUTE J = K - 1
                   MOVE CHAR-ITEM(J) TO CHAR-ITEM(K)
               END-PERFORM
               MOVE TEMP-CHAR TO CHAR-ITEM(1)
           END-IF.

       *> Resets the array back to "a" through "z"
       INIT-CHAR-LIST.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 26
               MOVE ALPHABET-INIT(I:1) TO CHAR-ITEM(I)
           END-PERFORM.

       *> Trims whitespace to find true length of current input word
       GET-WORD-LENGTH.
           MOVE 0 TO WORD-LEN.
           PERFORM VARYING I FROM 20 BY -1
                             UNTIL I < 1 OR INPUT-WORD(I:1) NOT = SPACE
               CONTINUE
           END-PERFORM.
           MOVE I TO WORD-LEN.

       *> ==========================================
       *> DISPLAY/LOGGING FORMATTERS
       *> ==========================================
       PRINT-ENCODED.
           MOVE SPACES TO DISPLAY-LINE.
           MOVE 1 TO DISP-POS.
           STRING "Encoded Array : [" DELIMITED BY SIZE
                  INTO DISPLAY-LINE WITH POINTER DISP-POS.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WORD-LEN
               MOVE ENCODED-NUMBERS(I) TO DISP-NUM
               IF I = WORD-LEN
                   STRING DISP-NUM DELIMITED BY SIZE
                          "]" DELIMITED BY SIZE
                          INTO DISPLAY-LINE WITH POINTER DISP-POS
               ELSE
                   STRING DISP-NUM DELIMITED BY SIZE
                          ", " DELIMITED BY SIZE
                          INTO DISPLAY-LINE WITH POINTER DISP-POS
               END-IF
           END-PERFORM.
           DISPLAY DISPLAY-LINE(1:DISP-POS).

       PRINT-DECODED.
           DISPLAY "Decoded Word  : " DECODED-WORD(1:WORD-LEN).
