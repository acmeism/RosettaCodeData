import Data.Complex (Complex, realPart)

type CD = Complex Double

quadraticRoots :: (CD, CD, CD) -> (CD, CD)
quadraticRoots (a, b, c)
  | 0 < realPart b =
    ( (2 * c) / (- b - d),
      (- b - d) / (2 * a)
    )
  | otherwise =
    ( (- b + d) / (2 * a),
      (2 * c) / (- b + d)
    )
  where
    d = sqrt $ b ^ 2 - 4 * a * c

main :: IO ()
main =
  mapM_
    (print . quadraticRoots)
    [ (3, 4, 4 / 3),
      (3, 2, -1),
      (3, 2, 1),
      (1, -10e5, 1),
      (1, -10e9, 1)
    ]
