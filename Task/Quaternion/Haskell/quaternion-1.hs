import Control.Monad (join)

data Quaternion a =
  Q a a a a
  deriving (Show, Eq)

realQ :: Quaternion a -> a
realQ (Q r _ _ _) = r

imagQ :: Quaternion a -> [a]
imagQ (Q _ i j k) = [i, j, k]

quaternionFromScalar :: (Num a) => a -> Quaternion a
quaternionFromScalar s = Q s 0 0 0

listFromQ :: Quaternion a -> [a]
listFromQ (Q a b c d) = [a, b, c, d]

quaternionFromList :: [a] -> Quaternion a
quaternionFromList [a, b, c, d] = Q a b c d

normQ :: (RealFloat a) => Quaternion a -> a
normQ = sqrt . sum . join (zipWith (*)) . listFromQ

conjQ :: (Num a) => Quaternion a -> Quaternion a
conjQ (Q a b c d) = Q a (-b) (-c) (-d)

instance (RealFloat a) => Num (Quaternion a) where
  (Q a b c d) + (Q p q r s) = Q (a + p) (b + q) (c + r) (d + s)
  (Q a b c d) - (Q p q r s) = Q (a - p) (b - q) (c - r) (d - s)
  (Q a b c d) * (Q p q r s) =
    Q
    (a * p - b * q - c * r - d * s)
    (a * q + b * p + c * s - d * r)
    (a * r - b * s + c * p + d * q)
    (a * s + b * r - c * q + d * p)
  negate (Q a b c d)        = Q (-a) (-b) (-c) (-d)
  abs q                     = quaternionFromScalar (normQ q)
  signum (Q 0 0 0 0)        = 0
  signum q@(Q a b c d)      = Q (a/n) (b/n) (c/n) (d/n) where n = normQ q
  fromInteger n             = quaternionFromScalar (fromInteger n)

main :: IO ()
main = do
  let q, q1, q2 :: Quaternion Double
      q  = Q 1 2 3 4
      q1 = Q 2 3 4 5
      q2 = Q 3 4 5 6
  print $ (Q 0 1 0 0) * (Q 0 0 1 0) * (Q 0 0 0 1) -- i*j*k; prints "Q (-1.0) 0.0 0.0 0.0"
  print $ q1 * q2                                 -- prints "Q (-56.0) 16.0 24.0 26.0"
  print $ q2 * q1                                 -- prints "Q (-56.0) 18.0 20.0 28.0"
  print $ q1 * q2 == q2 * q1                      -- prints "False"
  print $ imagQ q                                 -- prints "[2.0,3.0,4.0]"
