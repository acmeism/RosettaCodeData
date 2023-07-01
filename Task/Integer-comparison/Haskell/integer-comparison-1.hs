myCompare :: Integer -> Integer -> String
myCompare a b
  | a < b  = "A is less than B"
  | a > b  = "A is greater than B"
  | a == b = "A equals B"

main = do
  a <- readLn
  b <- readLn
  putStrLn $ myCompare a b
