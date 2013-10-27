import Data.List (mapAccumL)

fib = 1 : 2 : zipWith (+) fib (tail fib)

zeckendorf 0 = "0"
zeckendorf n = snd $ mapAccumL f n $ reverse $ takeWhile (<=n) fib where
	f n x | n < x     = (n,   '0')
              | otherwise = (n-x, '1')

main = mapM_ (putStrLn . zeckendorf) [0..20]
