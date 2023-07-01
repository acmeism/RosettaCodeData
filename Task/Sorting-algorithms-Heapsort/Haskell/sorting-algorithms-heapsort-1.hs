data Tree a = Nil
            | Node a (Tree a) (Tree a)
            deriving Show

insert :: Ord a => a -> Tree a -> Tree a
insert x Nil = Node x Nil Nil
insert x (Node y leftBranch rightBranch)
  | x < y = Node x (insert y rightBranch) leftBranch
  | otherwise = Node y (insert x rightBranch) leftBranch

merge :: Ord a => Tree a -> Tree a -> Tree a
merge Nil t = t
merge t Nil = t
merge tx@(Node vx lx rx) ty@(Node vy ly ry)
  | vx < vy = Node vx (merge lx rx) ty
  | otherwise = Node vy tx (merge ly ry)

fromList :: Ord a => [a] -> Tree a
fromList = foldr insert Nil

toList :: Ord a => Tree a -> [a]
toList Nil = []
toList (Node x l r) = x : toList (merge l r)

mergeSort :: Ord a => [a] -> [a]
mergeSort = toList . fromList
