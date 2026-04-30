import Data.Numbers.Primes
import Data.List

-- Translation of Wren ver1
deceptives1 :: [Int]
deceptives1 =
  [ n
  | (n, r) <- zip [17, 19 ..] (iterate ((11 +) . (100 *)) 1111111111111111)
  , not $ isPrime n, mod n 3 /= 0, mod n 5 /= 0, mod r (fromIntegral n) == 0
  ]

-- Translation of Wren ver2
deceptives2 :: [Int]
deceptives2 =
  [ n
  | n <- [49, 51 ..], mod n 3 /= 0, mod n 5 /= 0
  , not $ isPrime n, modPower (9 * n) 10 (pred n) == 1]

modPower :: Int -> Int -> Int -> Int
modPower base a b = foldl' mul 1 [p | (True, p) <- zip bs ps]
  where
    mul x y = mod (x * y) base
    bs = map odd $ takeWhile (0 <) $ iterate (flip div 2) b
    ps = iterate (\x -> mul x x) a
