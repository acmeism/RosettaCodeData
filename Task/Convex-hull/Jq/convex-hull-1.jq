# ccw returns true if the three points make a counter-clockwise turn
def ccw(a; b; c):
  a as [$ax, $ay]
  | b as [$bx, $by]
  | c as [$cx, $cy]
  | (($bx - $ax) * ($cy - $ay)) > (($by - $ay) * ($cx - $ax)) ;

def convexHull:
  if . == [] then []
  else sort as $pts
  # lower hull:
  | reduce $pts[] as $pt ([];
      until (length < 2 or ccw(.[-2]; .[-1]; $pt); .[:-1] )
      | . + [$pt] )
  # upper hull
  | (length + 1) as $t
  | reduce range($pts|length-2; -1; -1) as $i (.;
      $pts[$i] as $pt
      | until (length < $t or ccw(.[-2]; .[-1]; $pt); .[:-1] )
      | . + [$pt])
  | .[:-1]
  end ;
