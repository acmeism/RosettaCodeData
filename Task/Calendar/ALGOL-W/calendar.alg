BEGIN
    INTEGER WIDTH, YEAR;
    INTEGER COLS, LEAD, GAP;
    STRING(2) ARRAY WDAYS (0::6);
    RECORD MONTH ( STRING(9) MNAME; INTEGER DAYS, START_WDAY, AT_POS );
    REFERENCE(MONTH) ARRAY MONTHS(0::11);
    WIDTH := 80; YEAR := 1969;

    BEGIN
        WDAYS(0) := "Su"; WDAYS(1) := "Mo"; WDAYS(2) := "Tu";
        WDAYS(3) := "We"; WDAYS(4) := "Th"; WDAYS(5) := "Fr"; WDAYS(6) := "Sa";
        MONTHS( 0) := MONTH(" January",  31, 0, 0 );
        MONTHS( 1) := MONTH(" February", 28, 0, 0 );
        MONTHS( 2) := MONTH("  March",   31, 0, 0 );
        MONTHS( 3) := MONTH("  April",   30, 0, 0 );
        MONTHS( 4) := MONTH("   May",    31, 0, 0 );
        MONTHS( 5) := MONTH("   June",   30, 0, 0 );
        MONTHS( 6) := MONTH("   July",   31, 0, 0 );
        MONTHS( 7) := MONTH("  August",  31, 0, 0 );
        MONTHS( 8) := MONTH("September", 30, 0, 0 );
        MONTHS( 9) := MONTH(" October",  31, 0, 0 );
        MONTHS(10) := MONTH(" November", 30, 0, 0 );
        MONTHS(11) := MONTH(" December", 31, 0, 0 )
    END;

    BEGIN

        PROCEDURE SPACE(INTEGER VALUE N);
        BEGIN
            WHILE N > 0 DO BEGIN
                WRITEON(" "); N := N-1;
            END
        END SPACE;

        PROCEDURE INIT_MONTHS;
        BEGIN
            INTEGER I;

            IF YEAR REM 4 = 0 AND YEAR REM 100 NOT = 0 OR YEAR REM 400 = 0 THEN
                DAYS(MONTHS(1)) := 29;

            YEAR := YEAR-1;
            START_WDAY(MONTHS(0))
                := (YEAR * 365 + YEAR DIV 4 - YEAR DIV 100 + YEAR DIV 400 + 1) REM 7;

            FOR I := 1 STEP 1 UNTIL 12-1 DO
                START_WDAY(MONTHS(I)) :=
                    (START_WDAY(MONTHS(I-1)) + DAYS(MONTHS(I-1))) REM 7;

            COLS := (WIDTH + 2) DIV 22;
            WHILE 12 REM COLS NOT = 0 DO
                COLS := COLS-1;
            GAP := IF COLS - 1 NOT = 0 THEN (WIDTH - 20 * COLS) DIV (COLS - 1) ELSE 0;
            IF GAP > 4 THEN
                GAP := 4;
            LEAD := (WIDTH - (20 + GAP) * COLS + GAP + 1) DIV 2;
            YEAR := YEAR+1
        END INIT_MONTHS;

        PROCEDURE PRINT_ROW(INTEGER VALUE ROW);
        BEGIN
            INTEGER C, I, FROM, UP_TO;
            INTEGER PROCEDURE PREINCREMENT(INTEGER VALUE RESULT I);
            BEGIN I := I+1; I
            END PREINCREMENT;
            INTEGER PROCEDURE POSTINCREMENT(INTEGER VALUE RESULT I);
            BEGIN INTEGER PREV_VALUE;
                PREV_VALUE := I; I := I+1; PREV_VALUE
            END POSTINCREMENT;
            FROM := ROW * COLS;
            UP_TO := FROM + COLS;
            SPACE(LEAD);
            FOR C := FROM STEP 1 UNTIL UP_TO-1 DO BEGIN
                I := 9 % LENGTH OF MNAME(MONTHS(C)) % ;
                SPACE((20 - I) DIV 2);
                WRITEON(MNAME(MONTHS(C)));
                SPACE(20 - I - (20 - I) DIV 2 + (IF C = UP_TO - 1 THEN 0 ELSE GAP));
            END;
            WRITE();

            SPACE(LEAD);
            FOR C := FROM STEP 1 UNTIL UP_TO-1 DO BEGIN
                FOR I := 0 STEP 1 UNTIL 7-1 DO BEGIN
                    WRITEON(WDAYS(I)); IF I NOT = 6 THEN WRITEON(" ")
                END;
                IF C < UP_TO - 1 THEN
                    SPACE(GAP)
                ELSE
                    WRITE();
            END;
            WHILE BEGIN
                C := FROM;
                WHILE C < UP_TO AND AT_POS(MONTHS(C)) >= DAYS(MONTHS(C)) DO
                    C := C + 1;

                C NOT = UP_TO
            END DO BEGIN

                SPACE(LEAD);
                C := FROM;
                WHILE C < UP_TO DO BEGIN
                    I := 0;
                    WHILE I < START_WDAY(MONTHS(C)) DO BEGIN
                        I := I + 1;
                        SPACE(3)
                    END;
                    WHILE POSTINCREMENT(I) < 7 AND AT_POS(MONTHS(C)) < DAYS(MONTHS(C)) DO BEGIN
                        WRITEON(I_W := 2, S_W := 0, PREINCREMENT(AT_POS(MONTHS(C))));
                        IF I < 7 OR C < UP_TO - 1 THEN
                            SPACE(1)
                    END;
                    WHILE POSTINCREMENT(I) <= 7 AND C < UP_TO-1 DO
                        SPACE(3);
                    IF C < UP_TO - 1 THEN
                        SPACE(GAP - 1);
                    START_WDAY(MONTHS(C)) := 0;
                    C := C + 1
                END;
                WRITE();
            END;
            WRITE()
        END PRINT_ROW;

        PROCEDURE PRINT_YEAR;
        BEGIN
            INTEGER ROW, STRLEN, Y;
            STRLEN := 1;
            Y      := YEAR;
            WHILE Y > 9 DO BEGIN Y := Y DIV 10; STRLEN := STRLEN + 1 END;
            SPACE((WIDTH - STRLEN) DIV 2);
            WRITEON(I_W := 1, YEAR);
            WRITE(); WRITE();
            WHILE ROW * COLS < 12 DO BEGIN
                PRINT_ROW(ROW);
                ROW := ROW+1
            END
        END PRINT_YEAR;

        INIT_MONTHS;
        PRINT_YEAR
    END
END.
