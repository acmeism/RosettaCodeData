import Data.Tree (Tree(..), drawTree)

tree :: Tree Int
tree =
  Node
    1
    [ Node 2 [Node 4 [Node 7 []], Node 5 []]
    , Node 3 [Node 6 [Node 8 [], Node 9 []]]
    ]

main :: IO ()
main = (putStrLn . drawTree . fmap show) tree
