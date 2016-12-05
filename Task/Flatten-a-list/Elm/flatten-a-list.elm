import Graphics.Element exposing (show)

type Tree a
  = Leaf a
  | Node (List (Tree a))

flatten : Tree a -> List a
flatten tree =
  case tree of
    Leaf a -> [a]
    Node list -> List.concatMap flatten list

-- [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
tree : Tree Int
tree = Node
  [ Node [Leaf 1]
  , Leaf 2
  , Node [Node [Leaf 3, Leaf 4], Leaf 5]
  , Node [Node [Node []]]
  , Node [Node [Node [Leaf 6]]]
  , Leaf 7
  , Leaf 8
  , Node []
  ]

main =
  show (flatten tree)
