threeThree :: [Int] -> Bool
threeThree [] = False
threeThree  (3:3:3:_) = True
threeThree (_:xs) = threeThree xs

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    unlines $
      fmap
        (\xs -> show xs <> " -> " <> show (threeThree xs))
        [ [9, 3, 3, 3, 2, 1, 7, 8, 5],
          [5, 2, 9, 3, 3, 7, 8, 4, 1],
          [1, 4, 3, 6, 7, 3, 8, 3, 2],
          [1, 2, 3, 4, 5, 6, 7, 8, 9],
          [4, 6, 8, 7, 2, 3, 3, 3, 1]
        ]
