# Array/vector operations
def addVectors: transpose | map(add);

def multiply($m): map(. * $m);

def divide($d): map(1/$d);

def abs: map(.*.) | add | sqrt;


def orbitalStateVectors(semimajorAxis; eccentricity; inclination;
      longitudeOfAscendingNode; argumentOfPeriapsis; trueAnomaly):
  def mulAdd($v1; $x1; $v2; $x2):
    [($v1|multiply($x1)), ($v2|multiply($x2))] | addVectors;

  def rotate($i; $j; $alpha):
    [mulAdd($i;  $alpha|cos; $j; $alpha|sin),
     mulAdd($i; -$alpha|sin; $j; $alpha|cos)];

  [1, 0, 0] as $i
  | [0, 1, 0] as $j
  | [0, 0, 1] as $k
  | rotate($i; $j; longitudeOfAscendingNode) as [$i, $j]
  | rotate($j; $k; inclination) as [$j, $_]
  | rotate($i; $j; argumentOfPeriapsis) as [$i, $j]
  | (semimajorAxis * (if (eccentricity == 1) then 2 else (1 - eccentricity * eccentricity) end)) as $l
  | (trueAnomaly|cos) as $c
  | (trueAnomaly|sin) as $s
  | ($l / (1 + eccentricity * $c)) as $r
  | ($s * $r * $r / $l) as $rprime

  | mulAdd($i; $c; $j; $s) | multiply($r) as $position

  | mulAdd($i; $rprime * $c - $r * $s; $j; $rprime * $s + $r * $c)
  | divide(abs)
  | multiply( ((2 / $r) - (1 / semimajorAxis))|sqrt) as $speed
  | [$position, $speed] ;
