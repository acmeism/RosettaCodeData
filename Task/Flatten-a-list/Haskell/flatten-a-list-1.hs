import Data.Tree (Tree(..), flatten)

-- [[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]
-- implemented as multiway tree:
-- Data.Tree represents trees where nodes have values too, unlike the trees in our problem.
-- so we use a list as that value, where a node will have an empty list value,
-- and a leaf will have a one-element list value and no subtrees
list :: Tree [Int]
list =
  Node
    []
    [ Node [] [Node [1] []]
    , Node [2] []
    , Node [] [Node [] [Node [3] [], Node [4] []], Node [5] []]
    , Node [] [Node [] [Node [] []]]
    , Node [] [Node [] [Node [6] []]]
    , Node [7] []
    , Node [8] []
    , Node [] []
    ]

flattenList :: Tree [a] -> [a]
flattenList = concat . flatten

main :: IO ()
main = print $ flattenList list
