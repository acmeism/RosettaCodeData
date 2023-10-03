MAIN
    DEFINE
        i, pass SMALLINT,
        doors ARRAY[100] OF SMALLINT

    FOR i = 1 TO 100
        LET doors[i] = FALSE
    END FOR

    FOR pass = 1 TO 100
        FOR i = pass TO 100 STEP pass
            LET doors[i] = NOT doors[i]
        END FOR
    END FOR

    FOR i = 1 TO 100
        IF doors[i]
          THEN DISPLAY i USING "Door <<& is open"
          ELSE DISPLAY i USING "Door <<& is closed"
        END IF
    END FOR
END MAIN
