import Data.Monoid (mempty, (<>), getSum, getProduct)
import Control.Monad (join)
import Data.List (unfoldr)
import Data.Tuple (swap)

-- ETHIOPIAN MULTIPLICATION ---------------------------------------------------
ethMult
  :: (Monoid m)
  => Int -> m -> m
ethMult n m =
  foldr
    (\(d, x) a ->
        case d of
          0 -> a
          _ -> a <> x)
    mempty $
  zip
    (unfoldr
       (\h ->
           case h of
             0 -> Nothing
             _ -> Just . swap $ quotRem h 2)
       n)
    (iterate (join (<>)) m)

-- TEST -----------------------------------------------------------------------
main :: IO ()
main = do
  mapM_ print $
    [ getSum $ ethMult 17 34 -- 34 * 17
    , getProduct $ ethMult 3 34 -- 34 ^ 3
    ] <>
    (getProduct <$> ([ethMult 17] <*> [3, 4])) -- [3 ^ 17, 4 ^ 17]
  print $ ethMult 17 "34"
  print $ ethMult 17 [3, 4]
