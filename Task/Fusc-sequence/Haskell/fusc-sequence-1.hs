---------------------- FUSC SEQUENCE ---------------------

fusc :: Int -> Int
fusc i
  | 1 > i = 0
  | otherwise = fst $ go (pred i)
  where
    go n
      | 0 == n = (1, 0)
      | even n = (x + y, y)
      | otherwise = (x, x + y)
      where
        (x, y) = go (div n 2)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "First 61 terms:"
  print $ fusc <$> [0 .. 60]
  putStrLn "\n(Index, Value):"
  mapM_ print $ take 5 widths

widths :: [(Int, Int)]
widths =
  fmap
    (\(_, i, x) -> (i, x))
    (iterate nxtWidth (2, 0, 0))

nxtWidth :: (Int, Int, Int) -> (Int, Int, Int)
nxtWidth (w, i, v) = (succ w, j, x)
  where
    fi = (,) <*> fusc
    (j, x) =
      until
        ((w <=) . length . show . snd)
        (fi . succ . fst)
        (fi i)
