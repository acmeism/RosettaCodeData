import Data.Tuple (swap)
import Data.List (unfoldr)
import Control.Monad (join)

-- BY RHIND PAPYRUS 'EGYPTIAN' OR 'ETHIOPIAN' MULTIPLICATION ------------------
repString :: Int -> String -> String
repString n s =
  foldr
    (\(d, x) a ->
        if d > 0 -- Is this power of 2 needed for the binary recomposition ?
          then mappend a x
          else a)
    mempty $
  zip
    (unfoldr
       (\h ->
           if h > 0
             then Just $ swap (quotRem h 2) -- Binary decomposition of n
             else Nothing)
       n)
    (iterate (join mappend) s) -- Iterative duplication ( mappend to self )

-- TEST -----------------------------------------------------------------------
main :: IO ()
main = print $ repString 500 "ha"
