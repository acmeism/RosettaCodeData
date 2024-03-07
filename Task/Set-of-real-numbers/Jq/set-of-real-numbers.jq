include "realset" {search: "."};

def test_cases:
  { "(0, 1] ∪ [0, 2)":  ( [ [0,1], 1] | add( [0, [0,2]] )),
    "[0, 2) ∩ (1, 2]":  ( [ 0, [0,2]] | intersection( [[1,2],2] ) ),
    "[0, 3) − (0, 1)":  ( [ 0, [0,3]] | minus( [[0,1]] ) ),
    "[0, 3) − [0, 1]":  ( [ 0, [0,3]] | minus( [0, [0,1], 1] ))
  } ;

def keys_unsorted: keys;  # for gojq

def tests($values):
  "Checking containment of: \($values | join(" "))",
  (keys_unsorted[] as $name
   | "\($name) has length \(.[$name]|RealSetLength) and contains: \( [$values[] as $i | select(.[$name] | containsNumber($i) ) | $i] | join(" ") )" )
  ;

# A and B
def pi: 1 | atan * 4;

# For positive integers $n,
# we define B($n) to correspond to {x | 0 < x < $n and |sin(π x)| > 1/2}
def B($upper):
  def x: 0.5 | asin / pi;
  x as $x
  | reduce range(0; $upper) as $i ([];
      . + [ [$i + $x, $i + 1 - $x]]);

# |sin(π x²)| > 1/2
def A($upper):
  B($upper * $upper) | map( map(sqrt) );

# The simple tests:
test_cases | tests([0,1,2]),

# A - B
"|A - B| = \(A(10) | minus( B(10) ) | RealSetLength)"
