import Data.Array (array, bounds, range, (!))
import Data.Monoid (mappend)
import Data.List (sortBy)

compZig (x,y) (x',y') =           compare (x+y) (x'+y')
                        `mappend` if even (x+y) then compare x x'
                                                else compare y y'

zigZag upper = array b $ zip (sortBy compZig (range b))
                             [0..]
  where b = ((0,0),upper)
