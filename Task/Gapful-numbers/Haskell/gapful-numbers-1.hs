{-# LANGUAGE NumericUnderscores #-}

gapful :: Int -> Bool
gapful n = n `rem` firstLastDigit == 0
 where
  firstLastDigit = read [head asDigits, last asDigits]
  asDigits = show n

main :: IO ()
main = do
  putStrLn $ "\nFirst 30 Gapful numbers >= 100 :\n"  ++ r 30 [100,101..]
  putStrLn $ "\nFirst 15 Gapful numbers >= 1,000,000 :\n" ++ r 15 [1_000_000,1_000_001..]
  putStrLn $ "\nFirst 10 Gapful numbers >= 1,000,000,000 :\n" ++ r 10 [1_000_000_000,1_000_000_001..]
 where r n = show . take n . filter gapful
