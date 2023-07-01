perfect =
  (\x -> (2 ^ x - 1) * (2 ^ (x - 1))) <$>
  filter (\x -> isPrime x && isPrime (2 ^ x - 1)) maybe_prime
  where
    maybe_prime = scanl1 (+) (2 : 1 : cycle [2, 2, 4, 2, 4, 2, 4, 6])
    isPrime n = all ((/= 0) . (n `mod`)) $ takeWhile (\x -> x * x <= n) maybe_prime

isPerfect n = f n perfect
  where
    f n (p:ps) =
      case compare n p of
        EQ -> True
        LT -> False
        GT -> f n ps

main :: IO ()
main = do
  mapM_ print $ take 10 perfect
  mapM_ (print . (\x -> (x, isPerfect x))) [6, 27, 28, 29, 496, 8128, 8129]
