import Data.List (nub, sort)

-------------------- COMMON SORTED LIST ------------------

commonSorted :: Ord a => [[a]] -> [a]
commonSorted = sort . nub . concat

--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    commonSorted
      [ [5, 1, 3, 8, 9, 4, 8, 7],
        [3, 5, 9, 8, 4],
        [1, 3, 7, 9]
      ]
