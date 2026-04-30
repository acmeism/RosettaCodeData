import Data.List (delete)

selSort :: (Ord a) => [a] -> [a]
selSort [] = []
selSort xs = selSort (delete x xs) ++ [x]
  where x = maximum xs
