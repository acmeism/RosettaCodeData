import Data.Char (digitToInt)
isColorful :: Int -> Bool
isColorful n
  | n < 0 = error "Only non-negative integers are allowed"
  | n == 0 || n == 1 = True
  | 0 `elem` digits = False
  | 1 `elem` digits = False
  | not (distinct digits) = False
  | not (distinct subpros) = False
  | otherwise = True
  where
    digits = map digitToInt (show n)
    subpros =  [(prods !! i) `div` (prods !! j) |j <- [0..length(digits)], i <- [(j+1)..length(digits)]]
    prods = scanl (*) 1 digits

distinct :: Eq a => [a] -> Bool
distinct [] = True
distinct [a] = True
distinct (x:xs) = distinct xs && (x `notElem` xs)

-- Note, for s2, I started at 98762543 as it is the largest number that doesn't 'obviously' violate the colourful condition. Everything else either has 2*3 = 6; 2*4 = 8; 1 or 0 or a repeat digit. This was a rather random optimisation.
