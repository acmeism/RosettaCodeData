import Data.List (tails)

-- lazy convolution of a list by given kernel
conv :: Num a => [a] -> [a] -> [a]
conv ker = map (dot (reverse ker)) . tails  . pad
  where
    pad v = replicate (length ker - 1) 0 ++ v
    dot v = sum . zipWith (*) v

-- The lazy digital filter
dFilter :: [Double] -> [Double] -> [Double] -> [Double]
dFilter (a0:a) b s = tail res
  where
    res = (/ a0) <$> 0 : zipWith (-) (conv b s) (conv a res)
