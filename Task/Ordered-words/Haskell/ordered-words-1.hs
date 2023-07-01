-- Words are read from the standard input.  We keep in memory only the current
-- set of longest, ordered words.
--
-- Limitation: the locale's collation order is not take into consideration.

isOrdered wws@(_:ws) = and $ zipWith (<=) wws ws

longestOrderedWords = reverse . snd . foldl f (0,[]) . filter isOrdered
  where f (max, acc) w =
          let len = length w in
          case compare len max of
            LT -> (max, acc)
            EQ -> (max, w:acc)
            GT -> (len, [w])

main = do
  str <- getContents
  let ws = longestOrderedWords $ words str
  mapM_ putStrLn ws
