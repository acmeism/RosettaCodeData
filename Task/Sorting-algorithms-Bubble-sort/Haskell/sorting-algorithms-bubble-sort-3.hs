import Data.Maybe (fromMaybe)
import Control.Monad

bubbleSortBy ::  (a -> a -> Bool) -> [a] -> [a]
bubbleSortBy f as = case innerSort $ reverse as of
                         Nothing -> as
                         Just v  -> let (x:xs) = reverse v
                                   in x : bubbleSortBy f xs
    where innerSort (a:b:cs) = if b `f` a
                                  then liftM (a:) $ innerSort (b:cs)
                                  else Just $ b : fromMaybe (a:cs)
                                                (innerSort $ a:cs)
          innerSort _        = Nothing

bsort :: Ord a => [a] -> [a]
bsort =  bubbleSortBy (<)
