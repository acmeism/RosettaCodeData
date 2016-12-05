fizzBuzz : Nat -> String
fizzBuzz n = if (n `mod` 15) == 0 then "FizzBuzz"
             else if (n `mod` 3) == 0 then "Fizz"
             else if (n `mod` 5)  == 0 then "Buzz"
             else show n

main : IO ()
main = sequence_ $ map (putStrLn . fizzBuzz) [1..100]
