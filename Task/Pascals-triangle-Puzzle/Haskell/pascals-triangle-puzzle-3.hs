normalize :: [Rational] - [Integer]
normalize xs = [numerator (x * v) | x <- xs] where
  v = fromInteger $ foldr1 lcm $ map denominator $ xs

run puzzle = map (normalize . drop 3) $ answer where
  (a, m) = equations puzzle
  lr = decompose 0 m
  answer = case solve 0 lr a of
    Nothing - []
    Just x  - x : kernel lr
