import Data.Graph.Inductive.Internal.Heap(
  Heap(..),insert,findMin,deleteMin)

-- heapsort is added in this module as an example application

build :: Ord a => [(a,b)] -> Heap a b
build = foldr insert Empty

toList :: Ord a => Heap a b -> [(a,b)]
toList Empty = []
toList h = x:toList r
           where (x,r) = (findMin h,deleteMin h)

heapsort :: Ord a => [a] -> [a]
heapsort = (map fst) . toList . build . map (\x->(x,x))
