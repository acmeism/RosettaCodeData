       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. caesar-cipher.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION encrypt
    FUNCTION decrypt.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  plaintext                 PIC X(50).
01  offset                    USAGE BINARY-CHAR.
01  encrypted-str             PIC X(50).

PROCEDURE DIVISION.
    DISPLAY "Enter a message to encrypt: " WITH NO ADVANCING
    ACCEPT plaintext
    DISPLAY "Enter the amount to shift by: " WITH NO ADVANCING
    ACCEPT offset
    MOVE encrypt(offset, plaintext) TO encrypted-str
    DISPLAY "Encrypted: " encrypted-str
    DISPLAY "Decrypted: " decrypt(offset, encrypted-str).

END PROGRAM caesar-cipher.

IDENTIFICATION DIVISION.
FUNCTION-ID. encrypt.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION ALL INTRINSIC.

DATA DIVISION.
LOCAL-STORAGE SECTION.
01  i                         USAGE INDEX.
01  a                         USAGE BINARY-CHAR.
LINKAGE SECTION.
01  offset                    USAGE BINARY-CHAR.
01  str                       PIC X(50).
01  encrypted-str             PIC X(50).

PROCEDURE DIVISION USING offset, str RETURNING encrypted-str.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > LENGTH(str)
        IF str(i:1) IS NOT ALPHABETIC OR str(i:1) = SPACE
            MOVE str(i:1) TO encrypted-str(i:1)
            EXIT PERFORM CYCLE
        END-IF
        IF str(i:1) IS ALPHABETIC-UPPER
            MOVE ORD("A") TO a
        ELSE
            MOVE ORD("a") TO a
        END-IF
        MOVE CHAR(MOD(ORD(str(i:1)) - a + offset, 26) + a)
            TO encrypted-str(i:1)
    END-PERFORM
    EXIT FUNCTION.

END FUNCTION encrypt.

IDENTIFICATION DIVISION.
FUNCTION-ID. decrypt.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION encrypt.

DATA DIVISION.
LOCAL-STORAGE SECTION.
01  decrypt-offset            USAGE BINARY-CHAR.
LINKAGE SECTION.
01  offset                    USAGE BINARY-CHAR.
01  str                       PIC X(50).
01  decrypted-str             PIC X(50).

PROCEDURE DIVISION USING offset, str RETURNING decrypted-str.
    SUBTRACT offset FROM 26 GIVING decrypt-offset
    MOVE encrypt(decrypt-offset, str) TO decrypted-str
    EXIT FUNCTION.

END FUNCTION decrypt.
