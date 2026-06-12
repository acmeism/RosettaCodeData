include "polynomials" {search: "./"};

# Returns the Lagrange interpolating polynomial which passes through a list of points.
def lagrange($pts):
  ($pts|length) as $c
  | reduce range(0;$c) as $i ({polys: []};
      .poly = [1]
      | reduce range(0;$c) as $j (.;
          if ($i != $j)
          then .poly = (multiply(.poly; [-$pts[$j][0], 1]))
          else .
          end )
      | (.poly | eval($pts[$i][0])) as $d
      | .polys[$i] = (.poly | scalarDivide($d)) )
  | reduce range(0;$c) as $i (.sum = [0];
      .polys[$i] = (.polys[$i] | scalarMultiply($pts[$i][1]))
      | .sum = add(.sum; .polys[$i]) )
  | .sum ;

def pts: [
    [1, 1],
    [2, 4],
    [3, 1],
    [4, 5]
];

lagrange(pts) | pp
