import Data.Numbers.Primes (primes)

-- generates consecutive subsequences defined by given equivalence relation
consecutives equiv = filter ((> 1) . length) . go []
  where
    go r [] = [r]
    go [] (h : t) = go [h] t
    go (y : ys) (h : t)
      | y `equiv` h = go (h : y : ys) t
      | otherwise = (y : ys) : go [h] t

-- finds maximal values in a list and returns the first one
maximumBy g (h : t) = foldr f h t
  where
    f r x = if g r < g x then x else r

-- the task implementation
task ord n = reverse $ p + s : p : (fst <$> rest)
  where
    (p, s) : rest =
      maximumBy length $
        consecutives (\(_, a) (_, b) -> a `ord` b) $
          differences $
            takeWhile (< n) primes
    differences l = zip l $ zipWith (-) (tail l) l
