DECLARE SUB digitalRoot (what AS LONG)

'test inputs:
digitalRoot 627615
digitalRoot 39390
digitalRoot 588225

SUB digitalRoot (what AS LONG)
    DIM w AS LONG, t AS LONG, c AS INTEGER

    w = ABS(what)
    IF w > 10 THEN
        DO
            c = c + 1
            WHILE w
                t = t + (w MOD (10))
                w = w \ 10
            WEND
            w = t
            t = 0
        LOOP WHILE w > 9
    END IF
    PRINT what; ": additive persistance "; c; ", digital root "; w
END SUB
