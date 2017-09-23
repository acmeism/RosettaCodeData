pythagoreanTriplesBelow :: Int -> [[Int]]
pythagoreanTriplesBelow n =
  let m = quot n 2
  in concatMap
       (\x ->
           concatMap
             (\y ->
                 concatMap
                   (\z ->
                       if x + y + z <= n && x ^ 2 + y ^ 2 == z ^ 2
                         then [[x, y, z]]
                         else [])
                   [y + 1 .. m])
             [x + 1 .. m])
       [1 .. m]

-- TEST -------------------------------------------------------------------------
main :: IO ()
main =
  mapM_
    (print . length)
    ([id, filter (\[x, y, _] -> gcd x y == 1)] <*> [pythagoreanTriplesBelow 100])
