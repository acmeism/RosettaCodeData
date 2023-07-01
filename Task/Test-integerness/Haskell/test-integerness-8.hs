pithagoreanTriangles :: [[Integer]]
pithagoreanTriangles =
  [ [a, b, round c] | b <- [1..]
                    , a <- [1..b]
                    , let c = sqrt (fromInteger (a^2 + b^2))
                    , isInteger (c :: Double) ]
