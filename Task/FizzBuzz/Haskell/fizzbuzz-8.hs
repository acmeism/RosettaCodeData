fizzBuzz :: (Integral a) => a -> String
fizzBuzz i
  | fizz && buzz = "FizzBuzz"
  | fizz         = "Fizz"
  | buzz         = "Buzz"
  | otherwise    = show i
  where fizz = i `mod` 3 == 0
        buzz = i `mod` 5 == 0

main = mapM_ (putStrLn . fizzBuzz) [1..100]
