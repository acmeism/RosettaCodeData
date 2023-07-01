import Data.List

shift n l = l ++ replicate n 0

pad n l = replicate n 0 ++ l

norm :: Fractional a => [a] -> [a]
norm = dropWhile (== 0)

deg l = length (norm l) - 1

zipWith' op p q = zipWith op (pad (-d) p) (pad d q)
  where d = (length p) - (length q)

polydiv f g = aux (norm f) (norm g) []
  where aux f s q | ddif < 0 = (q, f)
                  | otherwise = aux f' s q'
           where ddif = (deg f) - (deg s)
                 k = (head f) / (head s)
                 ks = map (* k) $ shift ddif s
                 q' = zipWith' (+) q $ shift ddif [k]
                 f' = norm $ tail $ zipWith' (-) f ks
