replace :: Eq a => [a] -> [a] -> [a] -> [a]
replace a b = go
  where
    w = length a
    go [] = []
    go xxs@(x : xs)
      | a `isPrefixOf` xxs = b <> go (drop w xxs)
      | otherwise = x : go xs
