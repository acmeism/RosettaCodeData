import Data.Bool (bool)

fizzBuzz :: [String]
fizzBuzz =
  let fb n k = cycle $ replicate (pred n) [] <> [k]
   in zipWith
        (flip . bool <*> null)
        (zipWith (<>) (fb 3 "fizz") (fb 5 "buzz"))
        (show <$> [1 ..])

main :: IO ()
main = mapM_ putStrLn $ take 100 fizzBuzz
