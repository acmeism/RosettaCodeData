--------------------- FLOYDS TRIANGLE --------------------

floydTriangle :: [[Int]]
floydTriangle =
  ( zipWith
      (fmap (.) enumFromTo <*> (\a b -> pred (a + b)))
      <$> scanl (+) 1
      <*> id
  )
    [1 ..]


--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ (putStrLn . formatFT) [5, 14]

------------------------- DISPLAY ------------------------

formatFT :: Int -> String
formatFT n = unlines $ unwords . zipWith alignR ws <$> t
  where
    t = take n floydTriangle
    ws = length . show <$> last t

alignR :: Int -> Int -> String
alignR n =
  ( (<>)
      =<< flip replicate ' '
        . (-) n
        . length
  )
    . show
