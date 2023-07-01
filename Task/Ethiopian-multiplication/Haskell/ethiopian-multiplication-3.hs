import Control.Monad (join)
import Data.List (unfoldr)
import Data.Monoid (getProduct, getSum)
import Data.Tuple (swap)

----------------- ETHIOPIAN MULTIPLICATION ---------------

ethMult :: (Monoid m) => Int -> m -> m
ethMult n m =
  foldr addedWhereOdd mempty $
    zip (unfoldr half n) $ iterate (join (<>)) m

half :: Integral b => b -> Maybe (b, b)
half n
  | 0 /= n = Just . swap $ quotRem n 2
  | otherwise = Nothing

addedWhereOdd :: (Eq a, Num a, Semigroup p) => (a, p) -> p -> p
addedWhereOdd (d, x) a
  | 0 /= d = a <> x
  | otherwise = a

--------------------------- TEST -------------------------
main :: IO ()
main = do
  mapM_ print $
    [ getSum $ ethMult 17 34, -- 34 * 17
      getProduct $ ethMult 3 34 -- 34 ^ 3
    ]
      -- [3 ^ 17, 4 ^ 17]
      <> (getProduct <$> ([ethMult 17] <*> [3, 4]))
  print $ ethMult 17 "34"
  print $ ethMult 17 [3, 4]
