BEGIN

DECIMAL FUNCTION SQRT(X);
DECIMAL X;
BEGIN
    DECIMAL R1, R2, TOL;
    TOL := .00001;   % reasonable for most purposes %
    IF X >= 1.0 THEN
       BEGIN
          R1 := X;
          R2 := 1.0;
       END
    ELSE
       BEGIN
          R1 := 1.0;
          R2 := X;
       END;
    WHILE (R1-R2) > TOL DO
        BEGIN
            R1 := (R1+R2) / 2.0;
            R2 := X / R1;
        END;
    SQRT := R1;
END;

COMMENT - MAIN PROGRAM BEGINS HERE;

DECIMAL N, SQSUM, SQMEAN;

SQSUM := 0.0;
FOR N := 1.0 STEP 1.0 UNTIL 10.0 DO
    SQSUM := SQSUM + (N * N);
SQMEAN := SQSUM / (N - 1.0);
WRITE("RMS OF WHOLE NUMBERS 1.0 THROUGH 10.0 =", SQRT(SQMEAN));

END
