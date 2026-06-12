import Data.List (partition)

main :: IO ()
main =
  print $
    qSort
      "Is this misspelling of alphabetical as alphabitical a joke ?"

qSort :: (Ord a) => [a] -> [a]
qSort [] = []
qSort (x : xs) = qSort below <> (x : qSort above)
  where
    (below, above) = partition (<= x) xs
