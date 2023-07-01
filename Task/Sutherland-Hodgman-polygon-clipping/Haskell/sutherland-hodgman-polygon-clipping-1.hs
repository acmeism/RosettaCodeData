module SuthHodgClip (clipTo) where

import Data.List

type   Pt a = (a, a)
type   Ln a = (Pt a, Pt a)
type Poly a = [Pt a]

-- Return a polygon from a list of points.
polyFrom ps = last ps : ps

-- Return a list of lines from a list of points.
linesFrom pps@(_:ps) = zip pps ps

-- Return true if the point (x,y) is on or to the left of the oriented line
-- defined by (px,py) and (qx,qy).
(.|) :: (Num a, Ord a) => Pt a -> Ln a -> Bool
(x,y) .| ((px,py),(qx,qy)) = (qx-px)*(y-py) >= (qy-py)*(x-px)

-- Return the intersection of two lines.
(><) :: Fractional a => Ln a -> Ln a -> Pt a
((x1,y1),(x2,y2)) >< ((x3,y3),(x4,y4)) =
    let (r,s) = (x1*y2-y1*x2, x3*y4-y3*x4)
        (t,u,v,w) = (x1-x2, y3-y4, y1-y2, x3-x4)
        d = t*u-v*w
    in ((r*w-t*s)/d, (r*u-v*s)/d)

-- Intersect the line segment (p0,p1) with the clipping line's left halfspace,
-- returning the point closest to p1.  In the special case where p0 lies outside
-- the halfspace and p1 lies inside we return both the intersection point and
-- p1.  This ensures we will have the necessary segment along the clipping line.
(-|) :: (Fractional a, Ord a) => Ln a -> Ln a -> [Pt a]
ln@(p0, p1) -| clipLn =
    case (p0 .| clipLn, p1 .| clipLn) of
      (False, False) -> []
      (False, True)  -> [isect, p1]
      (True,  False) -> [isect]
      (True,  True)  -> [p1]
    where isect = ln >< clipLn

-- Intersect the polygon with the clipping line's left halfspace.
(<|) :: (Fractional a, Ord a) => Poly a -> Ln a -> Poly a
poly <| clipLn = polyFrom $ concatMap (-| clipLn) (linesFrom poly)

-- Intersect a target polygon with a clipping polygon.  The latter is assumed to
-- be convex.
clipTo :: (Fractional a, Ord a) => [Pt a] -> [Pt a] -> [Pt a]
targPts `clipTo` clipPts =
    let targPoly = polyFrom targPts
        clipLines = linesFrom (polyFrom clipPts)
    in foldl' (<|) targPoly clipLines
