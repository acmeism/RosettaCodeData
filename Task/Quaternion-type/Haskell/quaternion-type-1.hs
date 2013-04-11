import Control.Monad
import Control.Arrow
import Data.List

data Quaternion = Q Double Double Double Double
  deriving (Show, Ord, Eq)

realQ :: Quaternion -> Double
realQ (Q r _ _ _) = r

imagQ :: Quaternion -> [Double]
imagQ (Q _ i j k) = [i, j, k]

quaternionFromScalar s = Q s 0 0 0

listFromQ (Q a b c d) = [a,b,c,d]
quaternionFromList [a, b, c, d] = Q a b c d

addQ, subQ, mulQ :: Quaternion -> Quaternion -> Quaternion
addQ (Q a b c d) (Q p q r s) = Q (a+p) (b+q) (c+r) (d+s)

subQ (Q a b c d) (Q p q r s) = Q (a-p) (b-q) (c-r) (d-s)

mulQ (Q a b c d) (Q p q r s) =
  Q  (a*p - b*q - c*r - d*s)
     (a*q + b*p + c*s - d*r)
     (a*r - b*s + c*p + d*q)
     (a*s + b*r - c*q + d*p)

normQ  = sqrt. sum. join (zipWith (*)). listFromQ

conjQ, negQ :: Quaternion -> Quaternion
conjQ (Q a b c d) = Q a (-b) (-c) (-d)

negQ (Q a b c d) = Q (-a) (-b) (-c) (-d)
