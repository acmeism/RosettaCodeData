toPermutation :: Fact -> [Int]
toPermutation (Fact ds) = go (reverse ds) [0.. length ds - 1]
  where
    go [] p = p
    go (d:ds) p = case splitAt (fromIntegral d) p of
                    (a,x:b) -> x : go ds (a++b)
                    (a,[]) -> a

permute :: [a] -> [Int] -> [a]
permute s p = case splitAt (length s - length p) s of
                (s1,s2) -> s1 ++ map (s2 !!) p
