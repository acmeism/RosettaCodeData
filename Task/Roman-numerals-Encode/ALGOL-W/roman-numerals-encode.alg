BEGIN

PROCEDURE ROMAN (INTEGER VALUE NUMBER; STRING(15) RESULT CHARACTERS; INTEGER RESULT LENGTH);
    COMMENT
         Returns the Roman number of an integer between 1 and 3999.
         "MMMDCCCLXXXVIII" (15 characters long) is the longest Roman number under 4000;
    BEGIN
        INTEGER PLACE, POWER;

        PROCEDURE APPEND (STRING(1) VALUE C);
            BEGIN CHARACTERS(LENGTH|1) := C; LENGTH := LENGTH + 1 END;

        PROCEDURE I; APPEND(CASE PLACE OF ("I","X","C","M"));
        PROCEDURE V; APPEND(CASE PLACE OF ("V","L","D"));
        PROCEDURE X; APPEND(CASE PLACE OF ("X","C","M"));

        ASSERT (NUMBER >= 1) AND (NUMBER < 4000);

        CHARACTERS := "               ";
        LENGTH := 0;
        POWER := 1000;
        PLACE := 4;
        WHILE PLACE > 0 DO
            BEGIN
                CASE NUMBER DIV POWER + 1 OF BEGIN
                    BEGIN            END;
                    BEGIN I          END;
                    BEGIN I; I       END;
                    BEGIN I; I; I    END;
                    BEGIN I; V       END;
                    BEGIN V          END;
                    BEGIN V; I       END;
                    BEGIN V; I; I    END;
                    BEGIN V; I; I; I END;
                    BEGIN I; X       END
                END;
                NUMBER := NUMBER REM POWER;
                POWER := POWER DIV 10;
                PLACE := PLACE - 1
            END
    END ROMAN;

INTEGER I;
STRING(15) S;

ROMAN(1, S, I);    WRITE(S, I);
ROMAN(3999, S, I); WRITE(S, I);
ROMAN(3888, S, I); WRITE(S, I);
ROMAN(2009, S, I); WRITE(S, I);
ROMAN(405, S, I);  WRITE(S, I);
END.
