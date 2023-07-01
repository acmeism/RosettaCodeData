jewelCount
  :: Eq a
  => [a] -> [a] -> Int
jewelCount jewels = length . filter (`elem` jewels)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  print $ jewelCount "aA" "aAAbbbb"
  print $ jewelCount "z" "ZZ"
