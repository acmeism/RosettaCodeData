PROGRAM romberg(output);

CONST
   LOWER = -3.0;     { Lower bound of integration }
   UPPER = 3.0;      { Upper bound of integration }
   MAX  = 12;        { Maximum number of iterations }
   SIZE = MAX + 1;   { Array size (allowing for 1 based array indexing) }
   LIMIT = 5E-12;    { Convergence tolerance }

VAR
   a  : DOUBLE;      { Lower limit }
   b  : DOUBLE;      { Upper limit }
   r  : DOUBLE;      { Result}

FUNCTION Fn(x : DOUBLE) : DOUBLE;  { Function to be integrated. }
BEGIN
   {Fn := sin(x);  { f(x) = sin(x) }
   {Fn := 1.0 / x;  { f(x) = 1 / x }
   Fn := exp(x); {F(x) := exp(x)}
END;

FUNCTION power(base, exp : INTEGER) : INTEGER;  { Integer power function }
VAR
   r, m : INTEGER;
BEGIN
   r := 1;
   FOR m := 1 TO exp DO
      r := r * base;
   power := r;
END;


FUNCTION romberg(FUNCTION op(x : DOUBLE) : DOUBLE; a, b : DOUBLE; max : INTEGER) : DOUBLE;

VAR
   R  : ARRAY [1..SIZE, 1..SIZE] OF DOUBLE;

   h  : DOUBLE;   { Step size for current refinement }
   s0 : DOUBLE;   { f(a) + f(b), reused each iteration }
   s  : DOUBLE;   { Running sum of interior points }
   f  : DOUBLE;   { Richardson scaling factor (4^k) }
   d  : DOUBLE;   { Difference between estimates }
   i, j, k, n : INTEGER;  { Loop counters }

BEGIN
   h  := b - a;  { Initial step size }
   s0 := op(a) + op(b);  { Initial endpoint sum }
   n  := 1;  { Initial number of intervals = 2^i }

   i := 0;
   R[1,1] := s0 * h / 2.0;  { First trapezoid rule }

   REPEAT
      i := i + 1;  { Number of iterations }

      n := 2 * n;  { Double number of intervals }
      h := h / 2.0;  { New step size }

      s := s0 / 2.0;  { Start with half of f(a)+f(b) }

      FOR j := 1 TO n - 1 DO  { Compute interior points }
         s := s + op(a + j * h);

      R[i+1,1] := s * h;  { Initial estimate }

      f := 1.0;
      FOR k := 1 TO i DO  { Find Richardson extrapolation
                            R[i,k] = (4^k * R[i,k-1] - R[i-1,k-1]) / (4^k - 1) }
      BEGIN
         f := 4.0 * f;  { f = 4, 16, 64, ... }
         R[i+1, k+1] := (f * R[i+1, k] - R[i,k]) / (f - 1.0);
      END;

      d := ABS(R[i+1,i+1] - R[i,i]);
      WRITELN('I=', i:2, '     R= ', R[i+1,i+1]:22:15);
   UNTIL (i >= max) OR ( d < LIMIT);  { Stop when max iterations or limit reached }

   WRITELN;

   IF (i < MAX) THEN
      WRITELN('Converged early at I=', i:2)
   ELSE
      WRITELN('Max iterations reached');

   romberg := R[i+1,i+1];
END;


BEGIN
   a := LOWER;
   b := UPPER;
   r := romberg(Fn, a ,b , MAX);
   WRITELN('Integral =  ', r:22:15);
END.
