data Tree a
  = Leaf
  | Node
      Int
      (Tree a)
      a
      (Tree a)
  deriving (Show, Eq)

foldTree :: Ord a => [a] -> Tree a
foldTree = foldr insert Leaf

height :: Tree a -> Int
height Leaf = -1
height (Node h _ _ _) = h

depth :: Tree a -> Tree a -> Int
depth a b = succ (max (height a) (height b))

insert :: Ord a => a -> Tree a -> Tree a
insert v Leaf = Node 1 Leaf v Leaf
insert v t@(Node n left v_ right)
  | v_ < v = rotate $ Node n left v_ (insert v right)
  | v_ > v = rotate $ Node n (insert v left) v_ right
  | otherwise = t

max_ :: Ord a => Tree a -> Maybe a
max_ Leaf = Nothing
max_ (Node _ _ v right) =
  case right of
    Leaf -> Just v
    _ -> max_ right

delete :: Ord a => a -> Tree a -> Tree a
delete _ Leaf = Leaf
delete x (Node h left v right)
  | x == v =
    maybe left (rotate . (Node h left <*> (`delete` right))) (max_ right)
  | x > v = rotate $ Node h left v (delete x right)
  | x < v = rotate $ Node h (delete x left) v right

rotate :: Tree a -> Tree a
rotate Leaf = Leaf
rotate (Node h (Node lh ll lv lr) v r)
  -- Left Left.
  | lh - height r > 1 && height ll - height lr > 0 =
    Node lh ll lv (Node (depth r lr) lr v r)
rotate (Node h l v (Node rh rl rv rr))
  -- Right Right.
  | rh - height l > 1 && height rr - height rl > 0 =
    Node rh (Node (depth l rl) l v rl) rv rr
rotate (Node h (Node lh ll lv (Node rh rl rv rr)) v r)
  -- Left Right.
  | lh - height r > 1 =
    Node h (Node (rh + 1) (Node (lh - 1) ll lv rl) rv rr) v r
rotate (Node h l v (Node rh (Node lh ll lv lr) rv rr))
  -- Right Left.
  | rh - height l > 1 =
    Node h l v (Node (lh + 1) ll lv (Node (rh - 1) lr rv rr))
rotate (Node h l v r) =
  -- Re-weighting.
  let (l_, r_) = (rotate l, rotate r)
   in Node (depth l_ r_) l_ v r_

draw :: Show a => Tree a -> String
draw t = '\n' : draw_ t 0 <> "\n"
  where
    draw_ Leaf _ = []
    draw_ (Node h l v r) d = draw_ r (d + 1) <> node <> draw_ l (d + 1)
      where
        node = padding d <> show (v, h) <> "\n"
        padding n = replicate (n * 4) ' '

main :: IO ()
main = putStr $ draw $ foldTree [1 .. 31]
