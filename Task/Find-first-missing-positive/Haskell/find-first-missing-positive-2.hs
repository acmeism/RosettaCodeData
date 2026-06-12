---------- FIRST MISSING POSITIVE NATURAL NUMBER ---------

firstGap :: [Int] -> Int
firstGap xs = head $ filter (`notElem` xs) [1 ..]


--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    fmap
      (\xs -> show xs <> " -> " <> (show . firstGap) xs)
      [ [1, 2, 0],
        [3, 4, -1, 1],
        [7, 8, 9, 11, 12]
      ]
