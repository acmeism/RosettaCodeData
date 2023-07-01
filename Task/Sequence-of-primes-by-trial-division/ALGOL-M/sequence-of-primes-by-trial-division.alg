BEGIN

INTEGER I, K, M, N, S, NPRIMES, DIVISIBLE, FALSE, TRUE;

COMMENT COMPUTE P MOD Q;
INTEGER FUNCTION MOD (P, Q);
INTEGER P, Q;
BEGIN
  MOD := P - Q * (P / Q);
END;

COMMENT MAIN PROGRAM BEGINS HERE;

WRITE ("HOW MANY PRIMES DO YOU WANT TO GENERATE?");
READ (NPRIMES);
  BEGIN
    INTEGER ARRAY P[1:NPRIMES];
    FALSE := 0;
    TRUE := -1;

    % INITIALIZE P WITH FIRST (AND ONLY EVEN) PRIME NUMBER %
    P[1] := 2;
    WRITE (1, ":", P[1]);

    I := 1;  % COUNT OF PRIME NUMBERS FOUND SO FAR %
    K := 1;  % INDEX OF LARGEST PRIME <= SQRT OF N %
    N := 3;  % CURRENT NUMBER BEING CHECKED %
    WHILE I < NPRIMES DO
      BEGIN
        S := P[K] * P[K];
        IF S <= N THEN K := K + 1;
        DIVISIBLE := FALSE;
        M := 2;  % INDEX OF POSSIBLE DIVISORS (EXCLUDING 2) %
        WHILE M <= K AND DIVISIBLE = FALSE DO
          BEGIN
            IF MOD(N, P[M]) = 0 THEN DIVISIBLE := TRUE;
            M := M + 1;
          END;
        IF DIVISIBLE = FALSE THEN
          BEGIN
            I := I + 1;
            P[I] := N;
            WRITE (I, ":", N);
          END;
        N := N + 2;
      END;
  END;

END
