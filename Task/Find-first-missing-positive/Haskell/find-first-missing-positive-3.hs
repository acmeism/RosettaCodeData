import Data.Set (fromList, notMember)

---------- FIRST MISSING POSITIVE NATURAL NUMBER ---------

firstGap :: [Int] -> Int
firstGap xs = head $ filter (`notMember` seen) [1 ..]
  where
    seen = fromList xs
