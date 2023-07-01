# Raising a function to a power #

MODE FUN = PROC (REAL) REAL;
PROC pow = (FUN f, INT n, REAL x) REAL: f(x) ** n;
OP ** = (FUN f, INT n) FUN: pow (f, n, );

# Example: sin (3 x) = 3 sin (x) - 4 sin^3 (x) (follows from DeMoivre's theorem) #

REAL x = read real;
print ((new line, sin (3 * x),  3 *  sin (x) - 4 * (sin ** 3) (x)))
