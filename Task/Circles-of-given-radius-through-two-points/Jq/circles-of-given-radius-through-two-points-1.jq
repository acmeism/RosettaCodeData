# circle_centers is defined here as a filter.
# Input should be an array [x1, y1, x2, y2, r] giving the co-ordinates
# of the two points and a radius.
# If there is one solution, the output is the circle center;
# if there are two solutions centered at [x1, y1] and [x2, y2],
# then the output is [x1, y1, x2, y2];
# otherwise an explanatory string is returned.

def circle_centers:
  def sq: .*.;
  def c(x3; y1; y2; r; d): x3 + ((r|sq - ((d/2)|sq)) | sqrt) * (y1-y2)/d;

  .[0] as $x1 | .[1] as $y1 | .[2] as $x2 | .[3] as $y2 | .[4] as $r
  | ((($x2-$x1)|sq) + (($y2-$y1)|sq) | sqrt) as $d
  | (($x1+$x2)/2) as $x3
  | (($y1+$y2)/2) as $y3
  | c($x3; $y1; $y2; $r; $d) as $cx1
  | c($y3; $x2; $x2; $r; $d) as $cy1
  | (- c(-$x3; $y1; $y2; $r; $d)) as $cx2
  | (- c(-$y3; $x2; $x2; $r; $d)) as $cy2
  | if   $d == 0 and $r == 0 then [$x1, $y1]  # special case
    elif $d == 0     then "infinitely many circles can be drawn"
    elif $d >  $r*2  then "points are too far from each other"
    elif  0 >  $r    then "radius is not valid"
    elif ($cx1 and $cy1 and $cx2 and $cy2) | not then "no solution"
    else  [$cx1, $cy1, $cx2, $cy2 ]
    end;
