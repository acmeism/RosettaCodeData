PROC do sqnc = (INT max)INT:
BEGIN
    [max]INT a list;
    INT k1 := 2,
        lg2 := 1,
        v := a list[1] := a list[2] := 1; # Concurrent declaration and assignment #
                                          #           in declarations are allowed #
    INT nmax;
    LONG REAL amax := 0.0;

    INT mallows number;

    FOR n FROM 3 TO max DO
      v := a list[n] := a list[v] + a list[n-v];

      ( amax < v/n | amax := v/n; nmax := n );  # When given a Boolean as the 1st expression, #
                                                #   ( | ) is the short form of IF...THEN...FI #
      IF v/n >= 0.55 THEN           # This is the equivalent full form of the above construct #
          mallows number := n
      FI;

      IF ABS(BIN k1 AND BIN n) = 0 THEN
      # 'BIN' converts an INT type to a BITS type; In this context, 'ABS' reverses that operation #
        print(("Maximum between 2^",whole(lg2,0)," and 2^",whole(lg2+1,0)," is about ",fixed(amax,-10,8)));
        print((" at ",whole(nmax,0),newline));
        amax := 0;
        lg2 PLUSAB 1   # 'PLUSAB' (plus-and-becomes) has the short form +:= #
      FI;
      k1 := n
    OD;
    mallows number   # the result of the last expression evaluated is returned as the result of the PROC #
END;

print(("You too might have won $1000 with an answer of n = ", whole(do sqnc(2**20),0)))
