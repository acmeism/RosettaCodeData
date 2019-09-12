import Data.List (mapAccumL)

fib :: [Int]
fib = 1 : 2 : zipWith (+) fib (tail fib)

zeckendorf :: Int -> String
zeckendorf 0 = "0"
zeckendorf n = snd $ mapAccumL f n $ reverse $ takeWhile (<= n) fib
  where
    f n x
      | n < x = (n, '0')
      | otherwise = (n - x, '1')

main :: IO ()
main = (putStrLn . unlines) $ zeckendorf <$> [0 .. 20]
