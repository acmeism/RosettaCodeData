import Data.List (foldl', nub, sortOn) --' strict variant of foldl
import Data.Ord (comparing)
import Data.Tree (Tree (..), foldTree)

-------------------- LIST ROOTED TREES -------------------

bagPatterns :: Int -> [String]
bagPatterns n =
  nub $
    foldTree asBrackets
      . foldTree depthSorted
      . treeFromParentIndices
      <$> parentIndexPermutations n

--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn . unlines $ bagPatterns 5

----------------------- DEFINITIONS ----------------------

asBrackets :: a -> [String] -> String
asBrackets = const (('(' :) . (<> ")") . concat)

depthSorted :: a -> [Tree Int] -> Tree Int
depthSorted = const (Node <$> length <*> sortOn rootLabel)

parentIndexPermutations :: Int -> [[Int]]
parentIndexPermutations =
  traverse
    (enumFromTo 0)
    . enumFromTo 0
    . subtract 2

treeFromParentIndices :: [Int] -> Tree Int
treeFromParentIndices ixs =
  foldl' --' strict variant of foldl
    go
    (Node 0 [])
    (zip [1 .. length ixs] ixs)
  where
    go tree (i, x) = Node root forest
      where
        root = rootLabel tree
        nest = subForest tree
        forest
          | root == x = nest <> [Node i []]
          | otherwise = (`go` (i, x)) <$> nest
