-- With the exception of an initial 0, this is a list of all numbers whose
-- base-16 representations contain no decimal digits.
allNonDecimal :: [Int]
allNonDecimal = 0 : concatMap mulAdd allNonDecimal
  where mulAdd n = let m = n * 16 in map (m +) [10..15]

main :: IO ()
main = print $ takeWhile (< 500) $ tail allNonDecimal
