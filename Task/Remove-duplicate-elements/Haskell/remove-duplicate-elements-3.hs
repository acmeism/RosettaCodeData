import Data.Set

unique :: Ord a => [a] -> [a]
unique = loop empty
  where
    loop s []                    = []
    loop s (x : xs) | member x s = loop s xs
                    | otherwise  = x : loop (insert x s) xs
