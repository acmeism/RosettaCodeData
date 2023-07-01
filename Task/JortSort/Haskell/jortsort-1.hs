import Data.List (sort)

jortSort :: (Ord a) => [a] -> Bool
jortSort list = list == sort list
