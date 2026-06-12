dichotomicChain :: Integral a => a -> [a]
dichotomicChain n
  | n == 3  = [3, 2, 1]
  | n == 2 ^ log2 n = takeWhile (> 0) $ iterate (`div` 2) n
  | otherwise = let k = n `div` (2 ^ ((log2 n + 1) `div` 2))
                in chain n k
  where
    chain n1 n2
      | n2 <= 1 = dichotomicChain n1
      | otherwise = case n1 `divMod` n2 of
          (q, 0) -> dichotomicChain q `mul` dichotomicChain n2
          (q, r) -> [r] `add` (dichotomicChain q `mul` chain n2 r)

    c1 `mul` c2 = map (head c2 *) c1 ++ tail c2
    c1 `add` c2 = map (head c2 +) c1 ++ c2

    log2 = floor . logBase 2 . fromIntegral

binaryChain :: Integral a => a -> [a]
binaryChain 1 = [1]
binaryChain n | even n = n : binaryChain (n `div` 2)
              | odd n = n : binaryChain (n - 1)
