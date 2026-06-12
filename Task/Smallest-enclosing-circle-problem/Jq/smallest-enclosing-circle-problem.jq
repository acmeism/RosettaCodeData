# Vector sum of the input array of Points
def sum: transpose | map(add);

# The square of the distance between two points
def distSq:
  def sq: . * .;
  . as [$a, $b]
  | (($a[0] - $b[0]) | sq) +(($a[1] - $b[1]) | sq) ;

# The distance between two points
def distance:
  distSq | sqrt;

# Does the input Circle contain the point $p?
def contains($p):
  ([.center, $p] | distSq) <= .radius * .radius;

# Does the input Circle contain the given array of points?
def encloses($ps):
  . as $c
  | all($ps[]; . as $p | $c | contains($p));

# The center of a circle defined by 3 points
def getCircleCenter(bx; by; cx; cy):
  (bx*bx + by*by) as $b
  | (cx*cx + cy*cy) as $c
  | (bx*cy - by*cx) as $d
  | [(cy*$b - by*$c) / (2 * $d), (bx*$c - cx*$b) / (2 * $d)];

# The (smallest) circle that intersects 1, 2 or 3 distinct points
def Circle:
  if length == 1 then {center: .[0], radius: 0}
  elif length == 2
  then {center: (sum | map(./2)),
        radius: (distance/2) }

  elif length == 3
  then . as [$a, $b, $c]
  | ([getCircleCenter($b[0] - $a[0];
                      $b[1] - $a[1];
                      $c[0] - $a[0];
                      $c[1] - $a[1]), $a] | sum) as $i
  | {center: $i, radius: ([$i, $a]|distance)}
  else "Circle/0 expects an input array of from 1 to 3 Points" | error
  end;

# The smallest enclosing circle for n <= 3
def secTrivial:
  . as $rs
  | length as $length
  | if $length > 3 then "Internal error: secTrivial given more than 3 points." | error
    elif $length == 0 then [[0, 0]] | Circle
    elif $length <= 2 then Circle
    else first(
       range(0; 2) as $i
       | range($i+1; 3) as $j
       | ([$rs[$i], $rs[$j]] | Circle)
       | select(encloses($rs)) )
    // Circle
    end;

# Use the Welzl algorithm to find the SEC of the incoming array of points
def welzl:
  # Helper function:
  #   $rs is an array of points on the boundary;
  #   $n keeps track of how many points remain:
  def welzl_($rs; $n):
    if $n == 0 or ($rs|length) == 3
    then $rs | secTrivial
    else 0 as $idx     # or Rand($n)
    | .[$idx] as $p
    | .[$idx] = .[$n-1]
    | .[$n-1] = $p
    | welzl_($rs; $n-1) as $d
    | if ($d | contains($p)) then $d
      else welzl_($rs + [$p]; $n-1)
      end
    end ;

  welzl_([]; length);

def tests:
    [ [0, 0], [0, 1], [1, 0] ],
    [ [5, -2], [-3, -2], [-2, 5], [1, 6], [0, 2] ]
;

tests
| welzl
| "Circle(\(.center), \(.radius))"
