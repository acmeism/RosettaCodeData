divisors :: (Integral a) => a -> [a]
divisors n = filter ((0 ==) . (n `mod`)) [1 .. (n `div` 2)]

classOf :: (Integral a) => a -> Ordering
classOf n = compare (sum $ divisors n) n

main :: IO ()
main = do
  let classes = map classOf [1 .. 20000 :: Int]
      printRes w c = putStrLn $ w ++ (show . length $ filter (== c) classes)
  printRes "deficient: " LT
  printRes "perfect:   " EQ
  printRes "abundant:  " GT
