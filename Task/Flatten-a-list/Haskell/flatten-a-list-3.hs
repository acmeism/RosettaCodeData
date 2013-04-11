data NestedList a = NList [NestedList a] | Entry a

flatten :: NestedList a -> [a]
flatten nl = flatten' nl []
  where
    -- By passing through a list which the results will be preprended to we allow efficient lazy evaluation
    flatten' :: NestedList a -> [a] -> [a]
    flatten' (Entry a) cont = a:cont
    flatten' (NList entries) cont = foldr flatten' cont entries

example :: NestedList Int
example = NList [ NList [Entry 1], Entry 2, NList [NList [Entry 3, Entry 4], Entry 5], NList [NList [NList []]], NList [ NList [ NList [Entry 6]]], Entry 7, Entry 8, NList []]

main :: IO ()
main = print $ flatten example

-- output [1,2,3,4,5,6,7,8]
