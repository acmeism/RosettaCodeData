import Control.Monad
import Control.Monad.ListM (sortByM, insertByM, partitionM, minimumByM)
import Data.Bool (bool)
import Data.Monoid
import Data.List

--------------------------------------------------------------------------------
isortM, msortM, tsortM :: Monad m => (a -> a -> m Ordering) -> [a] -> m [a]

-- merge sort from the Control.Monad.ListM library
msortM = sortByM

-- insertion sort
isortM cmp = foldM (flip (insertByM cmp)) []

-- tree sort aka qsort (which is not)
tsortM cmp = go
  where
    go [] = pure []
    go (h:t) = do (l, g) <- partitionM (fmap (LT /=) . cmp h) t
                  go l <+> pure [h] <+> go g
    (<+>) = liftM2 (++)
