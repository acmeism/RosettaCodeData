joins :: String -> String -> Bool
joins left right = last left == head right

example :: [String]
example =
  [ unwords [w1, w2, w3, w4]
    | w1 <- ["the", "that", "a"],
      w2 <- ["frog", "elephant", "thing"],
      joins w1 w2,
      w3 <- ["walked", "treaded", "grows"],
      joins w2 w3,
      w4 <- ["slowly", "quickly"],
      joins w3 w4
  ]

main :: IO ()
main = print example
