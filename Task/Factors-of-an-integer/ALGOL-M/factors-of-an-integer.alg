BEGIN

COMMENT RETURN P MOD Q;
INTEGER FUNCTION MOD (P, Q);
INTEGER P, Q;
BEGIN
    MOD := P - Q * (P / Q);
END;

INTEGER I, N, LIMIT, FOUND, START, DELTA;

WHILE 1 = 1 DO
  BEGIN
    WRITE ("NUMBER TO FACTOR (OR 0 TO QUIT):");
    READ (N);
    IF N = 0 THEN GOTO DONE;
    WRITE ("THE FACTORS ARE:");

    COMMENT CHECK WHETHER NUMBER IS EVEN OR ODD;
    IF MOD(N, 2) = 0 THEN
      BEGIN
        START := 2;
        DELTA := 1;
      END
    ELSE
      BEGIN
        START := 3;
        DELTA := 2;
      END;

    COMMENT TEST POTENTIAL DIVISORS;
    FOUND := 0;
    I := START;
    LIMIT := N / I;
    WHILE I <= LIMIT DO
      BEGIN
        IF MOD(N, I) = 0 THEN
          BEGIN
            WRITEON (I);
            FOUND := FOUND + 1;
          END;
        I := I + DELTA;
        IF FOUND = 0 THEN LIMIT := N / I;
      END;
    IF FOUND = 0 THEN WRITEON (" NONE - THE NUMBER IS PRIME.");
    WRITE("");
  END;

DONE: WRITE ("GOODBYE");

END
