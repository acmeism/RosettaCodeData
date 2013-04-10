main:(
  INT two=2, thirty=30; # test constants #
  PROC VOID undefined;

# First implement exponentiation using a rather slow but sure FOR loop #
  PROC int pow = (INT base, exponent)INT: ( # PROC cannot be over loaded #
    IF exponent<0 THEN undefined FI;
    INT out:=( exponent=0 | 1 | base );
    FROM 2 TO exponent DO out*:=base OD;
    out
  );

  printf(($" One Gibi-unit is: int pow("g(0)","g(0)")="g(0)" - (cost: "g(0)
           " INT multiplications)"l$,two, thirty, int pow(two,thirty),thirty-1));

# implement exponentiation using a faster binary technique and WHILE LOOP #
  OP ** = (INT base, exponent)INT: (
    BITS binary exponent:=BIN exponent ; # do exponent arithmetic in binary #
    INT out := IF bits width ELEM binary exponent THEN base ELSE 1 FI;
    INT sq := IF exponent < 0 THEN undefined; ~ ELSE base FI;

    WHILE
      binary exponent := binary exponent SHR 1;
      binary exponent /= BIN 0
    DO
      sq *:= sq;
      IF bits width ELEM binary exponent THEN out *:= sq FI
    OD;
    out
  );

  printf(($" One Gibi-unit is: "g(0)"**"g(0)"="g(0)" - (cost: "g(0)
           " INT multiplications)"l$,two, thirty, two ** thirty,8));

  OP ** = (REAL in base, INT in exponent)REAL: ( # ** INT Operator can be overloaded #
    REAL base := ( in exponent<0 | 1/in base | in base);
    INT exponent := ABS in exponent;
    BITS binary exponent:=BIN exponent ; # do exponent arithmetic in binary #
    REAL out := IF bits width ELEM binary exponent THEN base ELSE 1 FI;
    REAL sq := base;

    WHILE
      binary exponent := binary exponent SHR 1;
      binary exponent /= BIN 0
    DO
      sq *:= sq;
      IF bits width ELEM binary exponent THEN out *:= sq FI
    OD;
    out
  );

  printf(($" One Gibi-unit is: "g(0,1)"**"g(0)"="g(0,1)" - (cost: "g(0)
           " REAL multiplications)"l$, 2.0, thirty, 2.0 ** thirty,8));

  OP ** = (REAL base, REAL exponent)REAL: ( # ** REAL Operator can be overloaded #
    exp(ln(base)*exponent)
  );

  printf(($" One Gibi-unit is: "g(0,1)"**"g(0,1)"="g(0,1)" - (cost: "
           "depends on precision)"l$, 2.0, 30.0, 2.0 ** 30.0))
)
