# v1 and v2 should be vectors of the same length.
def dotProduct(v1; v2): [v1, v2] | transpose | map(.[0] * .[1]) | add;

# Input: a vector
def norm: dotProduct(.; .) | sqrt;

# Input: a vector
def normalize: norm as $n | map(./$n);

# v1 and v2 should be 3-vectors
def crossProduct(v1; v2):
     [v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0]];

# v1 and v2 should be of equal length.
def getAngle(v1; v2):
   (dotProduct(v1; v2) / ((v1|norm) * (v2|norm)))|acos ;

# Input: a matrix (i.e. an array of same-length vectors)
# $v should be the same length as the vectors in the matrix
def matrixMultiply($v):
  map(dotProduct(.; $v)) ;

# $p - the point vector
# $v - the axis
# $a - the angle in radians
def aRotate($p; $v; $a):
    {ca: ($a|cos),
     sa: ($a|sin)}
    | .t = (1 - .ca)
    | .x = $v[0]
    | .y = $v[1]
    | .z = $v[2]
    | [
        [.ca + .x*.x*.t,    .x*.y*.t - .z*.sa, .x*.z*.t + .y*.sa],
        [.x*.y*.t + .z*.sa, .ca + .y*.y*.t,    .y*.z*.t - .x*.sa],
        [.z*.x*.t - .y*.sa, .z*.y*.t + .x*.sa, .ca + .z*.z*.t]
      ]
    | matrixMultiply($p) ;

def example:
    [5, -6,  4] as $v1
  | [8,  5,-30] as $v2
  | getAngle($v1; $v2) as $a
  | (crossProduct($v1; $v2) | normalize) as $ncp
  | aRotate($v1; $ncp; $a)
;

example
