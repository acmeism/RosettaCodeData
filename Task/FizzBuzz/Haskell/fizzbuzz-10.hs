fizzbuzz n = case (rem n 3, rem n 5) of
               (0, 0) -> "FizzBuzz"
               (0, _) -> "Fizz"
               (_, 0) -> "Buzz"
               (_, _) -> show n

main = mapM_ (putStrLn . fizzbuzz) [1..100]
