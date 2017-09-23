data Tree a
  = Leaf a
  | Node (Tree a)
         (Tree a)
  deriving (Show, Eq)

fringe :: Tree a -> [a]
fringe (Leaf x) = [x]
fringe (Node n1 n2) = fringe n1 ++ fringe n2

sameFringe
  :: (Eq a)
  => Tree a -> Tree a -> Bool
sameFringe t1 t2 = fringe t1 == fringe t2

main :: IO ()
main = do
  let a = Node (Leaf 1) (Node (Leaf 2) (Node (Leaf 3) (Node (Leaf 4) (Leaf 5))))
      b = Node (Leaf 1) (Node (Node (Leaf 2) (Leaf 3)) (Node (Leaf 4) (Leaf 5)))
      c = Node (Node (Node (Node (Leaf 1) (Leaf 2)) (Leaf 3)) (Leaf 4)) (Leaf 5)
      x =
        Node
          (Leaf 1)
          (Node
             (Leaf 2)
             (Node (Leaf 3) (Node (Leaf 4) (Node (Leaf 5) (Leaf 6)))))
      y = Node (Leaf 0) (Node (Node (Leaf 2) (Leaf 3)) (Node (Leaf 4) (Leaf 5)))
      z = Node (Leaf 1) (Node (Leaf 2) (Node (Node (Leaf 4) (Leaf 3)) (Leaf 5)))
  mapM_ print $ sameFringe a <$> [a, b, c, x, y, z]
