INT g = 7;
[]REAL p = []REAL(0.99999999999980993, 676.5203681218851,   -1259.1392167224028,
                771.32342877765313,   -176.61502916214059,     12.507343278686905,
                 -0.13857109526572012,   9.9843695780195716e-6, 1.5056327351493116e-7)[@0];

PROC complex gamma = (COMPL in z)COMPL: (
  # Reflection formula #
  COMPL z := in z;
  IF re OF z < 0.5 THEN
    pi / (complex sin(pi*z)*complex gamma(1-z))
  ELSE
    z -:= 1;
    COMPL x := p[0];
    FOR i TO g+1 DO x +:= p[i]/(z+i) OD;
    COMPL t := z + g + 0.5;
    complex sqrt(2*pi) * t**(z+0.5) * complex exp(-t) * x
  FI
);

OP ** = (COMPL z, p)COMPL: ( z=0|0|complex exp(complex ln(z)*p) );
PROC factorial = (COMPL n)COMPL: complex gamma(n+1);

FORMAT compl fmt = $g(-16, 8)"⊥"g(-10, 8)$;

test:(
  printf(($q"factorial(-0.5)**2="f(compl fmt)l$, factorial(-0.5)**2));
  FOR i TO 9 DO
    printf(($q"factorial("d")="f(compl fmt)l$, i, factorial(i)))
  OD
)
