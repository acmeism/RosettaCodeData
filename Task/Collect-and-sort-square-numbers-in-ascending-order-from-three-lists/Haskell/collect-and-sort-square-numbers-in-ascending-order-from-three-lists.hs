import Data.List (sort)

------- PERFECT SQUARE SUBSET OF THREE LISTS SORTED ------

squaresSorted :: Integral a => [[a]] -> [a]
squaresSorted = sort . concatMap (filter isPerfectSquare)

isPerfectSquare :: Integral a => a -> Bool
isPerfectSquare = (==) <*> ((^ 2) . floor . sqrt . fromIntegral)


--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    squaresSorted
      [ [3, 4, 34, 25, 9, 12, 36, 56, 36],
        [2, 8, 81, 169, 34, 55, 76, 49, 7],
        [75, 121, 75, 144, 35, 16, 46, 35]
      ]
