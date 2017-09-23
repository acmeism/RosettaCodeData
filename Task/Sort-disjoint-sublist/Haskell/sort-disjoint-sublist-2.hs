import Data.List (sort, elemIndex)

disjointSort :: [Int] -> [Int] -> [Int]
disjointSort xs indices =
  let indicesSorted = sort indices
      subsetSorted = sort $ (xs !!) <$> indicesSorted
  in (\(x, i) ->
         case elemIndex i indicesSorted of
           Nothing -> x
           Just iIndex -> subsetSorted !! iIndex) <$>
     zip xs [0 ..]

main :: IO ()
main = print $ disjointSort [7, 6, 5, 4, 3, 2, 1, 0] [6, 1, 7]
