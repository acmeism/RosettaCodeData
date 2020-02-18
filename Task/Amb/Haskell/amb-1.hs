import Control.Monad

amb = id

joins left right = last left == head right

example = do
  w1 <- amb ["the", "that", "a"]
  w2 <- amb ["frog", "elephant", "thing"]
  w3 <- amb ["walked", "treaded", "grows"]
  w4 <- amb ["slowly", "quickly"]
  guard (w1 `joins` w2)
  guard (w2 `joins` w3)
  guard (w3 `joins` w4)
  pure $ unwords [w1, w2, w3, w4]
