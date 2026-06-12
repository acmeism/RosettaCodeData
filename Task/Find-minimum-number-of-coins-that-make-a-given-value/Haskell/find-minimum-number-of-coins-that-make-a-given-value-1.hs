import Data.List (mapAccumL)
import Data.Tuple (swap)

----------------------- FIND CHANGE ----------------------

change :: [Int] -> Int -> [(Int, Int)]
change xs n = zip (snd $ mapAccumL go n xs) xs
  where
    go m v = swap (quotRem m v)


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ print $
    change [200, 100, 50, 20, 10, 5, 2, 1] 988
