instance (Eq a, Num a, ContainsInteger a) => ContainsInteger (Complex a) where
  isInteger z = isInteger (realPart z) && (imagPart z == 0)
