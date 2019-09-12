import Control.Monad

amb = id

joins left right = last left == head right

example = do
  w1 <- amb ["the", "that", "a"]
  w2 <- amb ["frog", "elephant", "thing"]
  w3 <- amb ["walked", "treaded", "grows"]
  w4 <- amb ["slowly", "quickly"]
  unless (joins w1 w2) (amb [])
  unless (joins w2 w3) (amb [])
  unless (joins w3 w4) (amb [])
  return (unwords [w1, w2, w3, w4])
