import Data.Array (Array, array, bounds, range, (!))
import Text.Printf (printf)
import Data.List (sortBy)

compZig :: (Int, Int) -> (Int, Int) -> Ordering
compZig (x, y) (x_, y_) = compare (x + y) (x_ + y_) <> go x y
  where
    go x y
      | even (x + y) = compare x x_
      | otherwise = compare y y_

zigZag :: (Int, Int) -> Array (Int, Int) Int
zigZag upper = array b $ zip (sortBy compZig (range b)) [0 ..]
  where
    b = ((0, 0), upper)
