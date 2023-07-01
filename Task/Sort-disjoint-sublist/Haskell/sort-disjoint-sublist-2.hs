import Data.Map as M (fromList, keys, lookup)
import Control.Applicative ((<|>))
import Data.Maybe (mapMaybe)
import Data.List (sort)

disjointSort :: [Int] -> [Int] -> [Int]
disjointSort ixs xs =
  let ks = sort ixs
      dctAll = fromList $ zip xs [0 ..]
      dctIx = fromList $ zip ks $ sort (mapMaybe (`M.lookup` dctAll) ks)
  in mapMaybe
       ((<|>) <$> (`M.lookup` dctIx) <*> (`M.lookup` dctAll))
       (keys dctAll)

main :: IO ()
main = print $ disjointSort [6, 1, 7] [7, 6, 5, 4, 3, 2, 1, 0]
