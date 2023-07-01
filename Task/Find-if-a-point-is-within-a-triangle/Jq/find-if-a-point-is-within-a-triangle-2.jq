def side(P1; P2; Q):
  [P1, P2, Q]
  | xy
  | (.y2 - .y1)*(.x3 - .x1) + (-.x2 + .x1)*(.y3 - .y1);

def naivePointInTriangle(P1; P2; P3; Q):
      side(P1; P2; Q) >= 0
  and side(P2; P3; Q) >= 0
  and side(P3; P1; Q) >= 0;

def pointInTriangleBoundingBox(P1; P2; P3; Q):
  [P1,P2,P3]
  | (map(.[0]) | min - EPS) as $xMin
  | (map(.[0]) | max + EPS) as $xMax
  | (map(.[1]) | min - EPS) as $yMin
  | (map(.[1]) | max + EPS) as $yMax
  | (Q[0] < $xMin or $xMax < Q[0] or Q[1] < $yMin or $yMax < Q[1]) | not;

def distanceSquarePointToSegment(P1; P2; Q):
  distanceSquared(P1; P2) as $p1_p2_squareLength
  | [P1, P2, Q]
  | xy
  | (((.x3 - .x1)*(.x2 - .x1) + (.y3 - .y1)*(.y2 - .y1)) / $p1_p2_squareLength) as $dotProduct
  | if $dotProduct < 0
    then sum_of_squares(.x3 - .x1, .y3 - .y1)
    elif $dotProduct <= 1
    then sum_of_squares(.x1 - .x3, .y1 - .y3) as $p_p1_squareLength
    |  $p_p1_squareLength - $dotProduct * $dotProduct * $p1_p2_squareLength
    else sum_of_squares(.x3 - .x2, .y3 - .y2)
    end;

def accuratePointInTriangle(P1; P2; P3; Q):
      if (pointInTriangleBoundingBox(P1; P2; P3; Q) | not)     then false
    elif naivePointInTriangle(P1; P2; P3; Q)                   then true
    elif distanceSquarePointToSegment(P1; P2; Q) <= EPS_SQUARE then true
    elif distanceSquarePointToSegment(P2; P3; Q) <= EPS_SQUARE then true
    elif distanceSquarePointToSegment(P3; P1; Q) <= EPS_SQUARE then true
    else false
    end;
