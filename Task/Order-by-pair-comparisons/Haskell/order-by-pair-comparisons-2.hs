ask a b = do
  putStr $ show a ++ " ≤ " ++ show b ++ " ? [y/n]  "
  bool GT LT . ("y" ==) <$> getLine

colors = ["Violet", "Red", "Green", "Indigo", "Blue", "Yellow", "Orange"]
