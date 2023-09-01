def aitken(f):
  . as $p0
  | f as $p1
  | ($p1|f) as $p2
  | ($p1 - $p0) as $p1m0
  | $p0 - $p1m0 * $p1m0 / ($p2 - 2 * $p1 + $p0);

def steffensenAitken(f; $pinit; $tol; $maxiter):
  { p0:  $pinit}
  | .p = (.p0|aitken(f))
  | .iter = 1
  | until( ((.p - .p0)|length) <= $tol or .iter >= $maxiter;
      .p0 = .p
      | .p = (.p0|aitken(f))
      | .iter += 1 )
  | if ((.p - .p0)|length > $tol) then null else .p end;

def deCasteljau($c0; $c1; $c2):
  (1 - .) as $s
  | ($s * $c0 + . * $c1) as $c01
  | ($s * $c1 + . * $c2) as $c12
  | $s * $c01 + . * $c12;

def xConvexLeftParabola:  deCasteljau(2; -8; 2);
def yConvexRightParabola: deCasteljau(1;  2; 3);

def implicitEquation($x; $y): 5 * $x * $x + $y - 5;

def f:
    xConvexLeftParabola as $x
  | yConvexRightParabola as $y
  | implicitEquation($x; $y) + . ;

def pp: . * 100 | round / 100;

foreach range (0; 11) as $i ( {t0:0};
  .emit = "t0 = \(.t0|pp): "
  | steffensenAitken(f; .t0; 0.00000001; 1000) as $t
  | if $t
    then ($t | xConvexLeftParabola) as $x
    |    ($t | yConvexRightParabola) as $y
    | if (implicitEquation($x; $y)|length) <= 0.000001
      then .emit += "intersection at \($x), \($y)"
      else .emit += "spurious solution"
      end
    else .emit += "no answer"
    end
  | .t0 += 0.1 )
| .emit
