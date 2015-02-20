       IDENTIFICATION DIVISION.
       PROGRAM-ID. iban-main.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  iban                    PIC X(50).
       01  iban-flag               PIC X.
           88  is-valid            VALUE "Y", FALSE "N".

       PROCEDURE DIVISION.
       main-line.
           MOVE "GB82 WEST 1234 5698 7654 32" TO iban
           PERFORM display-validity

           MOVE "GB82 TEST 1234 5698 7654 32" TO iban
           PERFORM display-validity

           GOBACK
           .
       display-validity.
           CALL "validate-iban" USING CONTENT iban, REFERENCE iban-flag
           IF is-valid
               DISPLAY FUNCTION TRIM(iban) " is valid."
           ELSE
               DISPLAY FUNCTION TRIM(iban) " is not valid."
           END-IF
           .
       END PROGRAM iban-main.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. validate-iban.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  country-lengths-area    VALUE "AD24AE23AL28AT20AZ28BA20BE16"
           & "BG22BH22BR29CH21CR21CY28CZ24DE22DK18DO28EE20ES24FI18FO18F"
           & "R27GB22GE22GI23GL18GR27GT28HR21HU28IE22IL23IS26IT27KW30KZ"
           & "20LB28LI21LT20LU20LV21MC27MD24ME22MK19MR27MT31MU30NL18NO1"
           & "5PK24PL28PS29PT25RO24RS22SA24SE24SI19SK24SM27TN24TR26VG24"
           .
           03  country-lengths     OCCURS 64 TIMES
                                   INDEXED BY country-lengths-idx.
               05  country-code    PIC XX.
               05  country-len     PIC 99.

       01  offset                  PIC 99.

       01  i                       PIC 99.

       01  len                     PIC 99.

       LINKAGE SECTION.
       01  iban                    PIC X(50).

       01  valid-flag              PIC X.
           88  is-valid            VALUE "Y", FALSE "N".

       PROCEDURE DIVISION USING iban, valid-flag.
           MOVE FUNCTION UPPER-CASE(iban) TO iban
           CALL "remove-spaces" USING iban

           *> Check if country-code and length are correct
           INITIALIZE len
           INSPECT iban TALLYING len FOR CHARACTERS BEFORE SPACE
           SET country-lengths-idx TO 1
           SEARCH country-lengths
               AT END
                   SET is-valid TO FALSE
                   GOBACK

               WHEN country-code (country-lengths-idx) = iban (1:2)
                   IF country-len (country-lengths-idx) NOT = len
                       SET is-valid TO FALSE
                       GOBACK
                   END-IF
           END-SEARCH

           CALL "create-iban-number" USING CONTENT len, REFERENCE iban

           *> Mod 97 number formed.
           IF FUNCTION MOD(iban, 97) = 1
               SET is-valid TO TRUE
           ELSE
               SET is-valid TO FALSE
           END-IF
           .

       IDENTIFICATION DIVISION.
       PROGRAM-ID. remove-spaces.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  i                       PIC 99.
       01  offset                  PIC 99.

       LINKAGE SECTION.
       01  str                     PIC X(50).

       PROCEDURE DIVISION USING str.
           INITIALIZE offset
           PERFORM VARYING i FROM 1 BY 1 UNTIL i > 50
               EVALUATE TRUE
                   WHEN str (i:1) = SPACE
                       ADD 1 TO offset

                   WHEN offset NOT = ZERO
                       MOVE str (i:1) TO str (i - offset:1)
               END-EVALUATE
           END-PERFORM
           MOVE SPACES TO str (50 - offset + 1:)
           .
       END PROGRAM remove-spaces.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. create-iban-number.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  first-four              PIC X(4).

       01  iban-num                PIC X(50).
       01  digit-num               PIC 99 VALUE 1.

       01  i                       PIC 99.

       01  letter-num              PIC 99.

       LINKAGE SECTION.
       01  len                     PIC 99.

       01  iban                    PIC X(50).

       PROCEDURE DIVISION USING len, iban.
           *> Move characters into final positions.
           MOVE iban (1:4) TO first-four
           MOVE iban (5:) TO iban
           MOVE first-four TO iban (len - 3:)

           *> Convert letters to numbers.
           INITIALIZE iban-num, digit-num ALL TO VALUE
           PERFORM VARYING i FROM 1 BY 1
                   UNTIL i > len OR iban (i:1) = SPACE
               IF iban (i:1) IS NUMERIC
                   MOVE iban (i:1) TO iban-num (digit-num:1)
                   ADD 1 TO digit-num
               ELSE
                   COMPUTE letter-num =
                       FUNCTION ORD(iban (i:1)) - FUNCTION ORD("A") + 10
                   MOVE letter-num TO iban-num (digit-num:2)
                   ADD 2 TO digit-num
               END-IF
           END-PERFORM

           MOVE iban-num TO iban
           .

       END PROGRAM create-iban-number.

       END PROGRAM validate-iban.
