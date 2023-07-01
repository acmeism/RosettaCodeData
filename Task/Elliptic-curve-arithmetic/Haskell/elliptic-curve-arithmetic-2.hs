import Data.Monoid

data Elliptic = Elliptic Double Double | Zero
   deriving Show

instance Eq Elliptic where
  p == q = dist p q < 1e-14
    where
      dist Zero Zero = 0
      dist Zero p = 1/0
      dist p Zero = 1/0
      dist (Elliptic x1 y1) (Elliptic x2 y2) = (x2-x1)^2 + (y2-y1)^2

inv Zero = Zero
inv (Elliptic x y) = Elliptic x (-y)
