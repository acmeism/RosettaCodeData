import Data.Monoid

fizzbuzz = max
       <$> show
       <*> "fizz" `when` divisibleBy 3
       <>  "buzz" `when` divisibleBy 5
       <>  "quxx" `when` divisibleBy 7
  where
    when m p x = if p x then m else mempty
    divisibleBy n x = x `mod` n == 0

main = mapM_ (putStrLn . fizzbuzz) [1..100]
