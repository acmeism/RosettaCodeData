perfectTotients :: [Int]
perfectTotients =
  filter ((==) <*> (succ . sum . tail . takeWhile (1 /=) . iterate φ)) [2 ..]

φ :: Int -> Int
φ = memoize (\n -> length (filter ((1 ==) . gcd n) [1 .. n]))

memoize :: (Int -> a) -> (Int -> a)
memoize f = (!!) (f <$> [0 ..])

main :: IO ()
main = print $ take 20 perfectTotients
