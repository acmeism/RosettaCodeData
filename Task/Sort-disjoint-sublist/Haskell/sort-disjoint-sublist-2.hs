import Data.Map as M (fromList, keys, lookup)
import Data.Maybe (mapMaybe)
import Data.List (sort)

disjointSort :: [Int] -> [Int] -> [Int]
disjointSort ixs xs =
  let dctAll = fromList $ zip xs [0 ..]
      ks = sort ixs
      dctIx = fromList $ zip ks $ sort (mapMaybe (`M.lookup` dctAll) ks)
  in mapMaybe
       (\k ->
           let mb = M.lookup k dctIx
           in case mb of
                Nothing -> M.lookup k dctAll
                _ -> mb)
       (keys dctAll)

main :: IO ()
main = print $ disjointSort [6, 1, 7] [7, 6, 5, 4, 3, 2, 1, 0]
