-------------------------- CANTOR ------------------------

cantor :: [(Bool, Int)] -> [(Bool, Int)]
cantor = concatMap go
  where
    go (bln, n)
      | bln && 1 < n =
          let m = quot n 3
           in [(True, m), (False, m), (True, m)]
      | otherwise = [(bln, n)]

--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ cantorLines 5

------------------------- DISPLAY ------------------------
cantorLines :: Int -> String
cantorLines n =
  unlines $
    showCantor
      <$> take n (iterate cantor [(True, 3 ^ pred n)])

showCantor :: [(Bool, Int)] -> String
showCantor = concatMap $ uncurry (flip replicate . c)
  where
    c True = '*'
    c False = ' '
