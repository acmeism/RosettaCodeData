import Data.Maybe (fromMaybe, maybe)

------------------- MULTIPLICATION TABLE -----------------

mulTable :: [Int] -> [[Maybe Int]]
mulTable xs =
  (Nothing : labels) :
  zipWith
    (:)
    labels
    [[upperMul x y | y <- xs] | x <- xs]
  where
    labels = Just <$> xs
    upperMul x y
      | x > y = Nothing
      | otherwise = Just (x * y)


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn . unlines $
    showTable . mulTable
      <$> [ [13 .. 20],
            [1 .. 12],
            [95 .. 100]
          ]

------------------------ FORMATTING ----------------------
showTable :: [[Maybe Int]] -> String
showTable xs = unlines $ head rows : [] : tail rows
  where
    w = succ $ (length . show) (fromMaybe 0 $ (last . last) xs)
    gap = replicate w ' '
    rows = (maybe gap (rjust w ' ' . show) =<<) <$> xs
    rjust n c = (drop . length) <*> (replicate n c <>)
