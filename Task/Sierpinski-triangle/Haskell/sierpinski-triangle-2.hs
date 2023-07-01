import Data.List (intercalate)

sierpinski :: Int -> [String]
sierpinski 0 = ["▲"]
sierpinski n =
  [ flip
      intercalate
      ([replicate (2 ^ (n - 1))] <*> " -"),
    (<>) <*> ('+' :)
  ]
    >>= (<$> sierpinski (n - 1))

main :: IO ()
main = mapM_ putStrLn $ sierpinski 4
