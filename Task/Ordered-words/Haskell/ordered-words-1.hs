-- Words are read from the standard input.  We keep in memory only the current
-- set of longest, ordered words.
--
-- Limitation: the locale's collation order is not take into consideration.

isOrdered wws@(_:ws) = and $ zipWith (<=) wws ws

keepLongest _ acc [] = acc
keepLongest max acc (w:ws) =
  let len = length w in
  case compare len max of
    LT -> keepLongest max acc ws
    EQ -> keepLongest max (w:acc) ws
    GT -> keepLongest len [w] ws

longestOrderedWords = reverse . keepLongest 0 [] . filter isOrdered

main = do
  str <- getContents
  let ws = longestOrderedWords $ words str
  mapM_ putStrLn ws
