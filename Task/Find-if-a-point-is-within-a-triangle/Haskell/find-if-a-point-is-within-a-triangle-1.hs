type Pt a = (a, a)

data Overlapping = Inside | Outside | Boundary
  deriving (Show, Eq)

data Triangle a = Triangle (Pt a) (Pt a) (Pt a)
  deriving Show

vertices (Triangle a b c) = [a, b, c]

-- Performs the affine transformation
-- which turns a triangle to Triangle (0,0) (0,s) (s,0)
-- where s is half of the triangles' area
toTriangle :: Num a => Triangle a -> Pt a -> (a, Pt a)
toTriangle t (x,y) = let
  [(x0,y0), (x1,y1), (x2,y2)] = vertices t
  s = x2*(y0-y1)+x0*(y1-y2)+x1*(-y0+y2)
  in  ( abs s
      , ( signum s * (x2*(-y+y0)+x0*(y-y2)+x*(-y0+y2))
        , signum s * (x1*(y-y0)+x*(y0-y1)+x0*(-y+y1))))

overlapping :: (Eq a, Ord a, Num a) =>
  Triangle a -> Pt a -> Overlapping
overlapping t p =  case toTriangle t p of
  (s, (x, y))
    | s == 0 && (x == 0 || y == 0)     -> Boundary
    | s == 0                           -> Outside
    | x > 0 && y > 0 && y < s - x      -> Inside
    | (x <= s && x >= 0) &&
      (y <= s && y >= 0) &&
      (x == 0 || y == 0 || y == s - x) -> Boundary
    | otherwise                        -> Outside
