import Data.List (genericLength, group, sort)

entropy
  :: (Ord a, Floating c)
  => [a] -> c
entropy =
  sum .
  map (negate . ((*) <*> logBase 2)) .
  (map =<< flip (/) . sum) . map genericLength . group . sort

main :: IO ()
main = print $ entropy "1223334444"
