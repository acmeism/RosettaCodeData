import Text.Printf (printf)

linearForm :: [Int] -> String
linearForm = strip . concat . zipWith term [1..]
  where
    term :: Int -> Int -> String
    term i c = case c of
      0  -> mempty
      1  -> printf "+e(%d)" i
      -1 -> printf "-e(%d)" i
      c  -> printf "%+d*e(%d)" c i

    strip str = case str of
      '+':s -> s
      ""    -> "0"
      s     -> s
