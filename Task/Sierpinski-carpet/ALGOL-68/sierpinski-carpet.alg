PROC in carpet = (INT in x, in y)BOOL: (
    INT x := in x, y := in y;
    BOOL out;
    DO
        IF x = 0 OR y = 0 THEN
            out := TRUE; GO TO stop iteration
        ELIF x MOD 3 = 1 AND y MOD 3 = 1 THEN
            out := FALSE; GO TO stop iteration
        FI;

        x %:= 3;
        y %:= 3
    OD;
    stop iteration: out
);

PROC carpet = (INT n)VOID:
    FOR i TO 3 ** n DO
        FOR j TO 3 ** n DO
            IF in carpet(i-1, j-1) THEN
                print("* ")
            ELSE
                print("  ")
            FI
        OD;
        print(new line)
    OD;

carpet(3)
