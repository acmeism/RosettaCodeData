import Data.Bool (bool)
import Data.Tree (Tree (..), drawForest, drawTree, foldTree)

---------------------- TREE TRAVERSAL --------------------

inorder, postorder, preorder :: a -> [[a]] -> [a]
inorder x [] = [x]
inorder x (y : xs) = y <> [x] <> concat xs

postorder x xs = concat xs <> [x]

preorder x xs = x : concat xs

levelOrder :: Tree a -> [a]
levelOrder = concat . levels

levels :: Tree a -> [[a]]
levels tree = go tree []
  where
    go (Node x xs) a =
      let (h, t) = case a of
            [] -> ([], [])
            (y : ys) -> (y, ys)
       in (x : h) : foldr go t xs

nodeCount,
  treeDepth,
  treeMax,
  treeMin,
  treeProduct,
  treeSum,
  treeWidth ::
    Int -> [Int] -> Int
nodeCount = const (succ . sum)
treeDepth = const (succ . foldr max 1)
treeMax x xs = maximum (x : xs)
treeMin x xs = minimum (x : xs)
treeProduct x xs = x * product xs
treeSum x xs = x + sum xs
treeWidth _ [] = 1
treeWidth _ xs = sum xs

treeLeaves :: Tree a -> [a]
treeLeaves = foldTree go
  where
    go x [] = [x]
    go _ xs = concat xs

--------------------------- TEST -------------------------
tree :: Tree Int
tree =
  Node
    1
    [ Node 2 [Node 4 [Node 7 []], Node 5 []],
      Node 3 [Node 6 [Node 8 [], Node 9 []]]
    ]

main :: IO ()
main = do
  putStrLn $ drawTree $ fmap show tree
  mapM_
    print
    ( [foldTree]
        <*> [preorder, inorder, postorder]
        <*> [tree]
    )
  print $ levelOrder tree
  putStrLn ""

  (putStrLn . unlines)
    ( ( \(k, f) ->
          justifyRight 7 ' ' k
            <> " -> "
            <> justifyLeft 6 ' ' (show $ foldTree f tree)
      )
        <$> [ ("Count", nodeCount),
              ("Layers", treeDepth),
              ("Max", treeMax),
              ("Min", treeMin),
              ("Product", treeProduct),
              ("Sum", treeSum),
              ("Leaves", treeWidth)
            ]
    )

justifyLeft, justifyRight :: Int -> Char -> String -> String
justifyLeft n c s = take n (s <> replicate n c)
justifyRight n c = (drop . length) <*> (replicate n c <>)
