import Data.List (elemIndex)

longPrimesUpTo :: Int -> [Int]
longPrimesUpTo n =
  filter isLongPrime $
    takeWhile (< n) primes
  where
    sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
    primes = sieve [2 ..]
    isLongPrime n = found
      where
        cycles = take n (iterate ((`mod` n) . (10 *)) 1)
        index = elemIndex (head cycles) $ tail cycles
        found = case index of
          (Just i) -> n - i == 2
          _ -> False

display :: Int -> IO ()
display n =
  if n <= 64000
    then do
      putStrLn
        ( show n <> " is "
            <> show (length $ longPrimesUpTo n)
        )
      display (n * 2)
    else pure ()

main :: IO ()
main = do
  let fiveHundred = longPrimesUpTo 500
  putStrLn
    ( "The long primes up to 35 are:\n"
        <> show fiveHundred
        <> "\n"
    )
  putStrLn ("500 is " <> show (length fiveHundred))
  display 1000
