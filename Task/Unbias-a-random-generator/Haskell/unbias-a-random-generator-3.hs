main = forM_ [3..6] showCounts
  where
    showCounts b = do
      r1 <- counts (randN b)
      r2 <- counts (unbiased (randN b))
      printf "n = %d  biased: %d%%  unbiased: %d%%\n" b r1 r2

    counts g = (`div` 100) . length . filter (== 1) <$> replicateM 10000 g
