data Tree a = Empty | Node a (Tree a) (Tree a)

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f Empty        = Empty
mapTree f (Node x l r) = Node (f x) (mapTree f l) (mapTree f r)
