data Tree a
  = Empty
  | Node { value :: a
         , left :: Tree a
         , right :: Tree a}

preorder, inorder, postorder, levelorder :: Tree a -> [a]
preorder Empty = []
preorder (Node v l r) = v : preorder l ++ preorder r

inorder Empty = []
inorder (Node v l r) = inorder l ++ (v : inorder r)

postorder Empty = []
postorder (Node v l r) = postorder l ++ postorder r ++ [v]

levelorder x = loop [x]
  where
    loop [] = []
    loop (Empty:xs) = loop xs
    loop (Node v l r:xs) = v : loop (xs ++ [l, r])

-- TEST --------------------------------------------------------------
tree :: Tree Int
tree =
  Node
    1
    (Node 2 (Node 4 (Node 7 Empty Empty) Empty) (Node 5 Empty Empty))
    (Node 3 (Node 6 (Node 8 Empty Empty) (Node 9 Empty Empty)) Empty)

asciiTree :: String
asciiTree =
  unlines
    [ "         1"
    , "        / \\"
    , "       /   \\"
    , "      /     \\"
    , "     2       3"
    , "    / \\     /"
    , "   4   5   6"
    , "  /       / \\"
    , " 7       8   9"
    ]

-- OUTPUT --------------------------------------------------------------
main :: IO ()
main = do
  putStrLn asciiTree
  mapM_ putStrLn $
    zipWith
      (\s xs -> justifyLeft 14 ' ' (s ++ ":") ++ unwords (show <$> xs))
      ["preorder", "inorder", "postorder", "level-order"]
      ([preorder, inorder, postorder, levelorder] <*> [tree])
  where
    justifyLeft n c s = take n (s ++ replicate n c)
