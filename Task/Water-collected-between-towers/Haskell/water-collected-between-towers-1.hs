import Data.Vector.Unboxed (Vector)
import qualified Data.Vector.Unboxed as V

waterCollected :: Vector Int -> Int
waterCollected =
  V.sum .            -- Sum of the water depths over each of
  V.filter (> 0) .   -- the columns that are covered by some water.
  (V.zipWith (-) =<< -- Where coverages are differences between:
   (V.zipWith min .  -- the lower water level in each case of:
    V.scanl1 max <*> -- highest wall to left, and
    V.scanr1 max))   -- highest wall to right.

main :: IO ()
main =
  mapM_
    (print . waterCollected . V.fromList)
    [ [1, 5, 3, 7, 2]
    , [5, 3, 7, 2, 6, 4, 5, 9, 1, 2]
    , [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1]
    , [5, 5, 5, 5]
    , [5, 6, 7, 8]
    , [8, 7, 7, 6]
    , [6, 7, 10, 7, 6]
    ]
