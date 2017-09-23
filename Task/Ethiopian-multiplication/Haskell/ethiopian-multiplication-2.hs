import Data.Tuple (swap)
import Data.List (unfoldr)
import Control.Monad (join)

-- ETHIOPIAN MULTIPLICATION ---------------------------------------------------
ethMult :: Int -> Int -> Int
ethMult n m =
  foldr
    (\(d, x) a ->
        if d > 0 -- Odd ?
          then (+) a x
          else a)
    0 $
  zip
    (unfoldr
       (\h ->
           if h > 0
             then Just $ swap (quotRem h 2) -- (half, (0|1) remainder)
             else Nothing)
       n)
    (iterate (join (+)) m) -- Iterative duplication ( add to self )

-- TEST -----------------------------------------------------------------------
main :: IO ()
main = print $ ethMult 17 34
