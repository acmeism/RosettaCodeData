------------------- PYTHAGOREAN TRIPLES ------------------

pythagoreanTriplesBelow :: Int -> [[Int]]
pythagoreanTriplesBelow n =
  concatMap
    ( \x ->
        concatMap
          (\y -> concatMap (go x y) [y + 1 .. m])
          [x + 1 .. m]
    )
    [1 .. m]
  where
    m = quot n 2
    go x y z
      | x + y + z <= n && x ^ 2 + y ^ 2 == z ^ 2 =
        [[x, y, z]]
      | otherwise = []

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (print . length)
    ( [id, filter (\[x, y, _] -> gcd x y == 1)]
        <*> [pythagoreanTriplesBelow 100]
    )
