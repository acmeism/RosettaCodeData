import qualified Data.Set as Set

unique :: Ord a => [a] -> [a]
unique = Set.toList . Set.fromList
