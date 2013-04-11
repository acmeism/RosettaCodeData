myCompare a b
  | a < b  = "A is less than B"
  | a > b  = "A is greater than B"
  | a == b = "A equals B"

main = do
  a' <- getLine
  b' <- getLine
  let { a :: Integer; a = read a' }
  let { b :: Integer; b = read b' }
  putStrLn $ myCompare a b
