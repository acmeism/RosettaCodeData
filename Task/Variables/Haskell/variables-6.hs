dotProduct :: [Int] -> [Int] -> Int
dotProduct ns ms = sum $ zipWith (+) ns ms
-- Without the type signature, dotProduct would
-- have a more general type.

foobar :: Num a => a
foobar = 15
-- Without the type signature, the monomorphism
-- restriction would cause foobar to have a less
-- general type.
