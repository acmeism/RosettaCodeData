MODE F = PROC (REAL)REAL;
OP ** = (REAL x, power)REAL: exp(ln(x)*power);

# Add a user defined function and its inverse #
PROC cube = (REAL x)REAL: x * x * x;
PROC cube root = (REAL x)REAL: x ** (1/3);

# First class functions allow run-time creation of functions from functions #
# return function compose(f,g)(x) == f(g(x)) #
PROC non standard compose = (F f1, f2)F: (REAL x)REAL: f1(f2(x)); # eg ELLA ALGOL 68RS #
PROC compose = (F f, g)F: ((F f2, g2, REAL x)REAL: f2(g2(x)))(f, g, );

# Or the classic "o" functional operator #
PRIO O = 5;
OP (F,F)F O = compose;

# first class functions should be able to be members of collection types #
[]F func list = (sin, cos, cube);
[]F arc func list = (arc sin, arc cos, cube root);

# Apply functions from lists as easily as integers #
FOR index TO UPB func list DO
  STRUCT(F f, inverse f) this := (func list[index], arc func list[index]);
  print(((inverse f OF this O f OF this)(.5), new line))
OD
