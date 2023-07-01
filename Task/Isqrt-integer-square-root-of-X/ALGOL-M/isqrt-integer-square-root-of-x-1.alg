BEGIN

COMMENT
    RETURN INTEGER SQUARE ROOT OF N USING QUADRATIC RESIDUE
    ALGORITHM. WARNING: THE FUNCTION WILL FAIL FOR X GREATER
    THAN 4095;
INTEGER FUNCTION ISQRT(X);
INTEGER X;
BEGIN
    INTEGER Q, R, Z, T;
    Q := 1;
    WHILE Q <= X DO
        Q := Q * 4;   % WARNING! OVERFLOW YIELDS 0 %
    Z := X;
    R := 0;
    WHILE Q > 1 DO
        BEGIN
           Q := Q / 4;
           T := Z - R - Q;
           R := R / 2;
           IF T >= 0 THEN
               BEGIN
                   Z := T;
                   R := R + Q;
               END;
        END;
    ISQRT := R;
END;

COMMENT - LET'S EXERCISE THE FUNCTION;

INTEGER I, COL;
WRITE("INTEGER SQUARE ROOT OF FIRST 65 NUMBERS:");
WRITE("");
COL := 1;
FOR I := 1 STEP 1 UNTIL 65 DO
    BEGIN
        WRITEON(ISQRT(I));
        COL := COL + 1;
        IF COL > 10 THEN
            BEGIN
                WRITE("");
                COL := 1;
            END;
    END;

WRITE("");
WRITE("     N    7^N  ISQRT");
WRITE("--------------------");
COMMENT - ODD POWERS OF 7 GREATER THAN 3 WILL CAUSE OVERFLOW;
FOR I := 1 STEP 2 UNTIL 3 DO
    BEGIN
        INTEGER POW7;
        POW7 := 7**I;
        WRITE(I, POW7, ISQRT(POW7));
    END;
WRITE("THAT'S ALL. GOODBYE.");

END
