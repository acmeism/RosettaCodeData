jewelCount
  :: Eq a
  => [a] -> [a] -> Int
jewelCount jewels = foldr go 0
  where
    go c
      | c `elem` jewels = succ
      | otherwise = id

--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ print $ uncurry jewelCount <$> [("aA", "aAAbbbb"), ("z", "ZZ")]
