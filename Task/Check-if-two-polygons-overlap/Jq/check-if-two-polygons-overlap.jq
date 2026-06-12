# Input: [$A, $B] where $A and $B are points
# Output: the vector $B - $A
def AB:
  . as [$A, $B]
  | [ $B[0] - $A[0],  $B[1] - $A[1]];

# Input: a vector
# Output: perpendicular
def perp: [- .[1], .[0]];

# dot product of this and $v, assumed to be of the same dimension
def dot($v):
  . as $this
  | reduce range(0; $this|length) as $i (0; . + ($this[$i] * $v[$i] ));

def getAxes:
  . as $poly
  | reduce range(0; $poly|length) as $i ([];
      $poly[$i] as $vertex1
      | $poly[if $i+1 == ($poly|length) then 0 else $i+1 end] as $vertex2
      | . + [ [$vertex1, $vertex2] | AB | perp] );

# emit {min, max}
def projectOntoAxis($axis):
  . as $poly
  | { max: - infinite, min: infinite }
  | reduce range(0; $poly|length) as $i (.;
       ($axis | dot( $poly[$i] )) as $p
       | if $p < .min then .min = $p else . end
       | if $p > .max then .max = $p else . end ) ;

def projectionsOverlap($proj1; $proj2):
  if   $proj1.max < $proj2.min then false
  elif $proj2.max < $proj1.min then false
  else true
  end;

# If there's an axis for which the projections do not overlap, then false; else true
def polygonsOverlap($poly1; $poly2):
  any( $poly1, $poly2 | getAxes[];
    . as $axis
    | ($poly1 | projectOntoAxis($axis)) as $proj1
    | ($poly2 | projectOntoAxis($axis)) as $proj2
    | projectionsOverlap($proj1; $proj2) | not)
  | not;

def poly1: [[0, 0], [0, 2], [1, 4], [2, 2], [2, 0]];
def poly2: [[4, 0], [4, 2], [5, 4], [6, 2], [6, 0]];
def poly3: [[1, 0], [1, 2], [5, 4], [9, 2], [9, 0]];

def task:
  "poly1 = \(poly1)",
  "poly2 = \(poly2)",
  "poly3 = \(poly3)",
  "",
  "poly1 and poly2 overlap? \(polygonsOverlap(poly1; poly2))",
  "poly1 and poly3 overlap? \(polygonsOverlap(poly1; poly3))",
  "poly2 and poly3 overlap? \(polygonsOverlap(poly2; poly3))"
  ;

task
