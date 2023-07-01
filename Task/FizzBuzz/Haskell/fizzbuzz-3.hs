main = mapM_ (putStrLn . fizzbuzz) [1..100]

fizzbuzz n =
    show n <|> [fizz| n `mod` 3 == 0] ++
               [buzz| n `mod` 5 == 0]

-- A simple default choice operator.
-- Defaults if both fizz and buzz fail, concats if any succeed.
infixr 0 <|>
d <|> [] = d
_ <|> x = concat x

fizz = "Fizz"
buzz = "Buzz"
