{-# LANGUAGE TupleSections #-}

import Data.Bifunctor (bimap)
import Data.Tree (Forest, Tree (..), drawTree, foldTree)

------------- TREE FROM NEST LEVELS (AND BACK) -----------

treeFromSparseLevels :: [Int] -> Tree (Maybe Int)
treeFromSparseLevels =
  Node Nothing
    . forestFromNestLevels
    . rooted
    . normalised

sparseLevelsFromTree :: Tree (Maybe Int) -> [Int]
sparseLevelsFromTree = foldTree go
  where
    go Nothing xs = concat xs
    go (Just x) xs = x : concat xs

forestFromNestLevels :: [(Int, a)] -> Forest a
forestFromNestLevels = go
  where
    go [] = []
    go ((n, v) : xs) =
      uncurry (:) $
        bimap (Node v . go) go (span ((n <) . fst) xs)

--------------------- TEST AND DISPLAY -------------------
main :: IO ()
main =
  mapM_
    ( \xs ->
        putStrLn ("From: " <> show xs)
          >> let tree = treeFromSparseLevels xs
              in putStrLn ((drawTree . fmap show) tree)
                   >> putStrLn
                     ( "Back to: "
                         <> show (sparseLevelsFromTree tree)
                         <> "\n\n"
                     )
    )
    [ [],
      [1, 2, 4],
      [3, 1, 3, 1],
      [1, 2, 3, 1],
      [3, 2, 1, 3],
      [3, 3, 3, 1, 1, 3, 3, 3]
    ]

----------- MAPPING TO A STRICTER DATA STRUCTURE ---------

-- Path from the virtual root to the first explicit node.
rooted :: [(Int, Maybe Int)] -> [(Int, Maybe Int)]
rooted [] = []
rooted xs = go $ filter ((1 <=) . fst) xs
  where
    go xs@((1, mb) : _) = xs
    go xs@((n, mb) : _) =
      fmap (,Nothing) [1 .. pred n] <> xs

-- Representation of implicit nodes.
normalised [] = []
normalised [x] = [(x, Just x)]
normalised (x : y : xs)
  | 1 < (y - x) =
    (x, Just x) :
    (succ x, Nothing) : normalised (y : xs)
  | otherwise = (x, Just x) : normalised (y : xs)
