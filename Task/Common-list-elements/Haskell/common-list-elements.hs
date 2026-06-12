import qualified Data.Set as Set

task :: Ord a => [[a]] -> [a]
task [] = []
task xs = Set.toAscList . foldl1 Set.intersection . map Set.fromList $ xs

main = print $ task  [[2,5,1,3,8,9,4,6], [3,5,6,2,9,8,4], [1,3,7,6,9]]
