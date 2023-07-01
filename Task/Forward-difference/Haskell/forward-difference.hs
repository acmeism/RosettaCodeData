forwardDifference :: Num a => [a] -> [a]
forwardDifference = tail >>= zipWith (-)

nthForwardDifference :: Num a => [a] -> Int -> [a]
nthForwardDifference = (!!) . iterate forwardDifference

main :: IO ()
main =
  mapM_ print $
  take 10 (iterate forwardDifference [90, 47, 58, 29, 22, 32, 55, 5, 55, 73])
