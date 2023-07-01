import Data.List (permutations, (\\))

latinSquare :: Eq a => [a] -> [a] -> [[a]]
latinSquare [] [] = []
latinSquare c r
  | head r /= head c = []
  | otherwise = reverse <$> foldl addRow firstRow perms
  where
    -- permutations grouped by the first element
    perms =
      tail $
        fmap
          (fmap . (:) <*> (permutations . (r \\) . return))
          c
    firstRow = pure <$> r
    addRow tbl rows =
      head
        [ zipWith (:) row tbl
          | row <- rows,
            and $ different (tail row) (tail tbl)
        ]
    different = zipWith $ (not .) . elem

printTable :: Show a => [[a]] -> IO ()
printTable tbl =
  putStrLn $
    unlines $
      unwords . map show <$> tbl
