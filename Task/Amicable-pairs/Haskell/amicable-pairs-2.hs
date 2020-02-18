import Data.Bool (bool)

amicablePairsUpTo :: Int -> [(Int, Int)]
amicablePairsUpTo n =
  let sigma = sum . properDivisors
  in [1 .. n] >>=
     (\x ->
         let y = sigma x
         in bool [] [(x, y)] (x < y && x == sigma y))

properDivisors
  :: Integral a
  => a -> [a]
properDivisors n =
  let root = (floor . sqrt) (fromIntegral n :: Double)
      lows = filter ((0 ==) . rem n) [1 .. root]
  in init $
     lows ++ drop (bool 0 1 (root * root == n)) (reverse (quot n <$> lows))

main :: IO ()
main = mapM_ print $ amicablePairsUpTo 20000
