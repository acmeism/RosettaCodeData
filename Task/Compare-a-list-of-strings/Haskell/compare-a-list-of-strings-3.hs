allEq
  :: Eq a
  => [a] -> Bool
allEq [] = True
allEq (h:t) =
  null . snd $
  until
    (\(x, xs) -> null xs || x /= head xs)
    (\(_, x:xs) -> (x, xs))
    (h, t)

allInc
  :: Ord a
  => [a] -> Bool
allInc [] = True
allInc (h:t) =
  null . snd $
  until
    (\(x, xs) -> null xs || x >= head xs)
    (\(_, x:xs) -> (x, xs))
    (h, t)
