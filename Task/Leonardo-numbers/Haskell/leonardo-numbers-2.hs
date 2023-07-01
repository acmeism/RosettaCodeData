leo :: Integer -> Integer -> Integer -> [Integer]
leo l0 l1 d = s where
  s = l0 : l1 : zipWith (\x y -> x + y + d) s (tail s)
