main = mapM_ (putStrLn . fizzbuzz) [1..100]

fizzbuzz x
    | x `mod` 15 == 0 = "FizzBuzz"
    | x `mod`  3 == 0 = "Fizz"
    | x `mod`  5 == 0 = "Buzz"
    | otherwise = show x
