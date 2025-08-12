isDoorOpen :: Integral a => a -> Bool
-- In Haskell, we are too lazy to open and close doors. Instead we
-- count how many times we would have toggled them, and then check if
-- that number is odd.
isDoorOpen doorNumber = odd numToggles
  where numToggles = length [ 1 | x <- [1..doorNumber], doorNumber `rem` x == 0]

main = do
  print $ "Open doors are " ++ show [x | x <- [0..100], isDoorOpen x]
