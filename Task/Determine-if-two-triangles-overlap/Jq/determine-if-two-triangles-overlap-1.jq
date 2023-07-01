# Points are realized as arrays of two numbers [x, y]

# Triangles are realized as triples of Points [p1, p2, p3]

# Input: a Triangle
def det2D:
  . as [ [$p1x, $p1y],  [$p2x, $p2y],  [$p3x, $p3y]]
  | $p1x * ($p2y - $p3y) +
    $p2x * ($p3y - $p1y) +
    $p3x * ($p1y - $p2y) ;

# Input: a Triangle
def checkTriWinding(allowReversed):
  if det2D < 0
  then if allowReversed
       then . as [$p1, $p2, $p3]
       | [$p1, $p3, $p2 ]
       else "Triangle has wrong winding direction" | error
       end
  else .
  end;

def boundaryCollideChk(eps): det2D < eps;

def boundaryDoesntCollideChk(eps): det2D <= eps;

def triTri2D($t1; $t2; $eps; $allowReversed; $onBoundary):
  def chkEdge:
    if $onBoundary then boundaryCollideChk($eps)
    else boundaryDoesntCollideChk($eps)
    end;

  # Triangles must be expressed anti-clockwise
  ($t1|checkTriWinding($allowReversed))
  |  ($t2|checkTriWinding($allowReversed))
  # 'onBoundary' determines whether points on boundary are considered as colliding or not
  # for each edge E of t1
  | first( range(0;3) as $i
        | (($i + 1) % 3) as $j
        # Check all points of t2 lie on the external side of edge E.
        # If they do, the triangles do not overlap.
        | if ([$t1[$i], $t1[$j], $t2[0]]| chkEdge) and
             ([$t1[$i], $t1[$j], $t2[1]]| chkEdge) and
             ([$t1[$i], $t1[$j], $t2[2]]| chkEdge)
          then 0
          else empty
  	  end) // true
  | if . == 0 then false
    else
    # for each edge E of t2
    first( range(0;3) as $i
        |  (($i + 1) % 3) as $j
        # Check all points of t1 lie on the external side of edge E.
        # If they do, the triangles do not overlap.
        | if ([$t2[$i], $t2[$j], $t1[0]] | chkEdge) and
             ([$t2[$i], $t2[$j], $t1[1]] | chkEdge) and
             ([$t2[$i], $t2[$j], $t1[2]] | chkEdge)
	  then 0
	  else empty
	  end) // true
    | if . == 0 then false
      else true # The triangles overlap
      end
    end ;
