data Tree a
  = Leaf a
  | Node [Tree a]

flatten :: Tree a -> [a]
flatten (Leaf x) = [x]
flatten (Node xs) = xs >>= flatten

main :: IO ()
main =
  (print . flatten) $
  Node
    [ Node [Leaf 1]
    , Leaf 2
    , Node [Node [Leaf 3, Leaf 4], Leaf 5]
    , Node [Node [Node []]]
    , Node [Node [Node [Leaf 6]]]
    , Leaf 7
    , Leaf 8
    , Node []
    ]

-- [1,2,3,4,5,6,7,8]
