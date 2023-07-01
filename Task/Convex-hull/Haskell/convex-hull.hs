import Data.List (sortBy, groupBy, maximumBy)
import Data.Ord (comparing)

(x, y) = ((!! 0), (!! 1))

compareFrom
  :: (Num a, Ord a)
  => [a] -> [a] -> [a] -> Ordering
compareFrom o l r =
  compare ((x l - x o) * (y r - y o)) ((y l - y o) * (x r - x o))

distanceFrom
  :: Floating a
  => [a] -> [a] -> a
distanceFrom from to = ((x to - x from) ** 2 + (y to - y from) ** 2) ** (1 / 2)

convexHull
  :: (Floating a, Ord a)
  => [[a]] -> [[a]]
convexHull points =
  let o = minimum points
      presorted = sortBy (compareFrom o) (filter (/= o) points)
      collinears = groupBy (((EQ ==) .) . compareFrom o) presorted
      outmost = maximumBy (comparing (distanceFrom o)) <$> collinears
  in dropConcavities [o] outmost

dropConcavities
  :: (Num a, Ord a)
  => [[a]] -> [[a]] -> [[a]]
dropConcavities (left:lefter) (right:righter:rightest) =
  case compareFrom left right righter of
    LT -> dropConcavities (right : left : lefter) (righter : rightest)
    EQ -> dropConcavities (left : lefter) (righter : rightest)
    GT -> dropConcavities lefter (left : righter : rightest)
dropConcavities output lastInput = lastInput ++ output

main :: IO ()
main =
  mapM_ print $
  convexHull
    [ [16, 3]
    , [12, 17]
    , [0, 6]
    , [-4, -6]
    , [16, 6]
    , [16, -7]
    , [16, -3]
    , [17, -4]
    , [5, 19]
    , [19, -8]
    , [3, 16]
    , [12, 13]
    , [3, -4]
    , [17, 5]
    , [-3, 15]
    , [-3, -9]
    , [0, 11]
    , [-9, -3]
    , [-4, -2]
    , [12, 10]
    ]
