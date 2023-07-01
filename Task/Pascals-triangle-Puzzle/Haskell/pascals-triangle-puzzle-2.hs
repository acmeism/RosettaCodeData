triangle n = n * (n+1) `div` 2

coeff xys x = maybe 0 id $ lookup x xys

row n cs = [coeff cs k | k <- [1..n]]

eqXYZ n = [(0, 1:(-1):1:replicate n 0)]

eqPyramid n h = do
  a <- [1..h-1]
  x <- [triangle (a-1) + 1 .. triangle a]
  let y = x+a
  return $ (0, 0:0:0:row n [(x,-1),(y,1),(y+1,1)])

eqConst n fields = do
  (k,s) <- zip [1..] fields
  guard $ not $ null s
  return $ case s of
    "X" - (0, 1:0:0:row n [(k,-1)])
    "Y" - (0, 0:1:0:row n [(k,-1)])
    "Z" - (0, 0:0:1:row n [(k,-1)])
    _   - (fromInteger $ read s, 0:0:0:row n [(k,1)])

equations :: [[String]] - ([Rational], [[Rational]])
equations puzzle = unzip eqs where
  fields = concat puzzle
  eqs = eqXYZ n ++ eqPyramid n h ++ eqConst n fields
  h = length puzzle
  n = length fields
