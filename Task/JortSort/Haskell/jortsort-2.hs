import Data.List (sort)

jortSort
  :: (Ord a)
  => [a] -> Bool
jortSort = (==) <*> sort

--------------------------- TEST ---------------------------
main :: IO ()
main = print $ jortSort <$> [[4, 5, 1, 3, 2], [1, 2, 3, 4, 5]]
