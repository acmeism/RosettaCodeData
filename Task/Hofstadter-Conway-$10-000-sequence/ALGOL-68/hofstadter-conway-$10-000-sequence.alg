PROC do sqnc = (INT max)INT:
BEGIN
    [max]INT a list;
    INT k1 := 2,
        lg2 := 1,
        v := a list[1] := a list[2] := 1; # Concurrent declaration and assignment in declarations are allowed #

    INT nmax;
    LONG REAL amax := 0.0;

    INT mallows number;

    FOR n FROM 3 TO max DO
      v := a list[n] := a list[v] + a list[n-v];

      ( amax < v/n | amax := v/n; nmax := n );  # When given a Boolean as the 1st expression, ( | ) is the short form of IF...THEN...FI #

      IF v/n >= 0.55 THEN                       # This is the equivalent full form of the above construct #
          mallows number := n
      FI;

      IF ABS(BIN k1 AND BIN n) = 0 THEN
      # 'BIN' converts an INT type to a BITS type; In this context, 'ABS' reverses that operation #
        printf(($"Maximum between 2^"g(0)" and 2^"g(0)" is about "g(-10,8)" at "g(0)l$, lg2,lg2+1, amax, nmax));
        amax := 0;
        lg2 PLUSAB 1   # 'PLUSAB' (plus-and-becomes) has the short form +:= #
      FI;
      k1 := n
    OD;
    mallows number   # the result of the last expression evaluated is returned as the result of the PROC #
END;

INT mallows number = do sqnc(2**20); # This definition of 'mallows number' does not clash with the variable
                                       of the same name inside PROC do sqnc - they are in different scopes#

printf(($"You too might have won $1000 with an answer of n = "g(0)$, mallows number))
