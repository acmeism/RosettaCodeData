import Data.List (mapAccumL)


-------------- CUMULATIVE STANDARD DEVIATION -------------

cumulativeStdDevns :: [Float] -> [Float]
cumulativeStdDevns = snd . mapAccumL go (0, 0) . zip [1.0..]
  where
    go (s, q) (i, x) =
      let _s = s + x
          _q = q + (x ^ 2)
      in ((_s, _q), sqrt ((_q / i) - ((_s / i) ^ 2)))



--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ print $ cumulativeStdDevns [2, 4, 4, 4, 5, 5, 7, 9]
