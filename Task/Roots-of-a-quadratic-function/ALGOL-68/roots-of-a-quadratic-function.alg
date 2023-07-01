quadratic equation:
BEGIN

  MODE ROOTS  = UNION([]REAL, []COMPL);
  MODE QUADRATIC = STRUCT(REAL a,b,c);

  PROC solve  = (QUADRATIC q)ROOTS:
  BEGIN
    REAL a = a OF q, b = b OF q, c = c OF q;
    REAL sa = b**2 - 4*a*c;
    IF sa >=0 THEN # handle the +ve case as REAL #
      REAL sqrt sa = ( b<0 | sqrt(sa) | -sqrt(sa));
      REAL r1 = (-b + sqrt sa)/(2*a),
           r2 = (-b - sqrt sa)/(2*a);
      []REAL((r1,r2))
    ELSE # handle the -ve case as COMPL conjugate pairs #
      COMPL compl sqrt sa = ( b<0 | complex sqrt(sa) | -complex sqrt(sa));
      COMPL r1 = (-b + compl sqrt sa)/(2*a),
            r2 = (-b - compl sqrt sa)/(2*a);
      []COMPL (r1, r2)
    FI
  END # solve #;

  PROC real  evaluate = (QUADRATIC q, REAL x )REAL:  (a OF q*x + b OF q)*x + c OF q;
  PROC compl evaluate = (QUADRATIC q, COMPL x)COMPL: (a OF q*x + b OF q)*x + c OF q;

  # only a very tiny difference between the 2 examples #
  []QUADRATIC test = ((1, -10e5, 1), (1, 0, 1), (1,-3,2), (1,3,2), (4,0,4), (3,4,5));

  FORMAT real fmt = $g(-0,8)$;
  FORMAT compl fmt = $f(real fmt)"+"f(real fmt)"i"$;
  FORMAT quadratic fmt = $f(real fmt)" x**2 + "f(real fmt)" x + "f(real fmt)" = 0"$;

  FOR index TO UPB test DO
    QUADRATIC quadratic = test[index];
    ROOTS r = solve(quadratic);

# Output the two different scenerios #
    printf(($"Quadratic: "$, quadratic fmt, quadratic, $l$));
    CASE r IN
      ([]REAL r):
        printf(($"REAL x1 = "$, real fmt, r[1],
                   $", x2 = "$, real fmt, r[2],  $"; "$,
                $"REAL y1 = "$, real fmt, real evaluate(quadratic,r[1]),
                   $", y2 = "$, real fmt, real evaluate(quadratic,r[2]), $";"ll$
        )),
      ([]COMPL c):
        printf(($"COMPL x1,x2 = "$, real fmt, re OF c[1], $"+/-"$,
                                    real fmt, ABS im OF c[1], $"; "$,
                  $"COMPL y1 = "$, compl fmt, compl evaluate(quadratic,c[1]),
                      $", y2 = "$, compl fmt, compl evaluate(quadratic,c[2]), $";"ll$
        ))
    ESAC
  OD
END # quadratic_equation #
