import Data.Tree (Tree(..))

preorder :: a -> [[a]] -> [a]
preorder x xs = x : concat xs

inorder :: a -> [[a]] -> [a]
inorder x [] = [x]
inorder x (y:xs) = y ++ [x] ++ concat xs

postorder :: a -> [[a]] -> [a]
postorder x xs = concat xs ++ [x]

foldTree :: (a -> [b] -> b) -> Tree a -> b
foldTree f = go
  where
    go (Node x ts) = f x (go <$> ts)

levelOrder :: Tree a -> [a]
levelOrder x =
  takeWhile (not . null) (iterate (concatMap subForest) [x]) >>= fmap rootLabel

-- TEST -------------------------------------------------
tree :: Tree Int
tree =
  Node
    1
    [ Node 2 [Node 4 [Node 7 []], Node 5 []]
    , Node 3 [Node 6 [Node 8 [], Node 9 []]]
    ]

main :: IO ()
main = do
  mapM_ print ([foldTree] <*> [preorder, inorder, postorder] <*> [tree])
  print $ levelOrder tree
