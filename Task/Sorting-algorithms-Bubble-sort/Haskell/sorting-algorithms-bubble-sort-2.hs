import Data.Maybe (fromMaybe)
import Control.Monad

bsort :: Ord a => [a] -> [a]
bsort s = maybe s bsort $ _bsort s
  where _bsort (x:x2:xs) = if x > x2
            then Just $ x2 : fromMaybe (x:xs) (_bsort $ x:xs)
            else liftM (x:) $ _bsort (x2:xs)
        _bsort _         = Nothing
