isMonic :: (Eq a, Num a) => [a] -> Bool
isMonic = ([1] ==) . take 1 . normalized

shortDivMonic :: (Eq a, Num a) => [a] -> [a] -> ([a], [a])
shortDivMonic p1 p2
  | isZero p2 = error "zero divisor"
  | not (isMonic p2) = error "divisor is not monic"
  | otherwise =
      let go 0 p = p
          go i (h:t) = h : go (i-1) (zipWith (+) (map (h *) ker) t)
      in splitAt k $ go k p1
    where
      k = length p1 - length as
      _:as = normalized p2
      ker = negate <$> as ++ repeat 0
