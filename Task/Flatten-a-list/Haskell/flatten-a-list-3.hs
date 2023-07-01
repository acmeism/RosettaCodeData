data NestedList a
  = NList [NestedList a]
  | Entry a

flatten :: NestedList a -> [a]
flatten nl = flatten_ nl []
  where
    flatten_ :: NestedList a -> [a] -> [a]
    flatten_ (Entry a) cont = a : cont
    flatten_ (NList entries) cont = foldr flatten_ cont entries

-- By passing through a list to which the results will be prepended,
-- we allow for efficient lazy evaluation
example :: NestedList Int
example =
  NList
    [ NList [Entry 1]
    , Entry 2
    , NList [NList [Entry 3, Entry 4], Entry 5]
    , NList [NList [NList []]]
    , NList [NList [NList [Entry 6]]]
    , Entry 7
    , Entry 8
    , NList []
    ]

main :: IO ()
main = print $ flatten example
-- output [1,2,3,4,5,6,7,8]
