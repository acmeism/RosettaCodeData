import Prelude (foldr, maximum, (==), (+))
import Data.Map (insertWith', empty, filter, elems, keys)

mode :: (Ord a) => [a] -> [a]
mode xs = keys (filter (== maximum (elems counts)) counts)
  where counts = foldr (\x -> insertWith' (+) x 1) empty xs
