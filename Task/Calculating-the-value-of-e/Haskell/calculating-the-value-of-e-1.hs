------ APPROXIMATION OF E OBTAINED AFTER N ITERATIONS ----

eApprox :: Int -> Double
eApprox n =
  (sum . take n) $ (1 /) <$> scanl (*) 1 [1 ..]

--------------------------- TEST -------------------------
main :: IO ()
main = print $ eApprox 20
