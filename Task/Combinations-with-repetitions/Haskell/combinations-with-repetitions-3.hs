--------------- COMBINATIONS WITH REPETITION -------------

combinationsWithRepetition ::
  (Eq a) =>
  Int ->
  [a] ->
  [[a]]
combinationsWithRepetition k xs = cmb k []
  where
    cmb 0 ys = ys
    cmb n [] = cmb (pred n) (pure <$> xs)
    cmb n peers = cmb (pred n) (peers >>= nextLayer)
      where
        nextLayer [] = []
        nextLayer ys@(h : _) =
          (: ys) <$> dropWhile (/= h) xs


-------------------------- TESTS -------------------------
main :: IO ()
main = do
  print $
    combinationsWithRepetition
      2
      ["iced", "jam", "plain"]
  print $ length $ combinationsWithRepetition 3 [0 .. 9]
