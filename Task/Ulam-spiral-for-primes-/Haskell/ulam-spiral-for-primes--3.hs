showTable w = foldMap (putStrLn . foldMap pad)
  where pad s = take w $ s ++ repeat ' '
