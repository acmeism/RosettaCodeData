# determinant of 2x2 matrix
def det(a;b;c;d): a*d - b*c ;

# Input: an array representing a line (L1)
# Output: the intersection of L1 and L2 unless the lines are judged to be parallel
# This implementation uses "destructuring" to assign local variables
def lineIntersection(L2):
  .    as [[$ax,$ay], [$bx,$by]]
  | L2 as [[$cx,$cy], [$dx,$dy]]
  | {detAB: det($ax;$ay; $bx;$by),
     detCD: det($cx;$cy; $dx;$dy),
     abDx: ($ax - $bx),
     cdDx: ($cx - $dx),
     abDy: ($ay - $by),
     cdDy: ($cy - $dy)}
  | . + {xnom:  det(.detAB;.abDx;.detCD;.cdDx),
         ynom:  det(.detAB;.abDy;.detCD;.cdDy),
         denom: det(.abDx; .abDy;.cdDx; .cdDy) }
  | if (.denom|length < 10e-6)  # length/0 emits the absolute value
    then error("lineIntersect: parallel lines")
    else [.xnom/.denom, .ynom/.denom]
    end ;
