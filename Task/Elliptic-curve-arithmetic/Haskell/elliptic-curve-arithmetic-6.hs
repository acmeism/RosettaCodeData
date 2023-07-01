n `mult` p
  | n == 0 = Zero
  | n == 1 = p
  | n == 2 = p <> p
  | n < 0  = inv ((-n) `mult` p)
  | even n = 2 `mult` ((n `div` 2) `mult` p)
  | odd n  = p <> (n -1) `mult` p
