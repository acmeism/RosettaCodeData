accumulatingReverse :: [a] -> [a]
accumulatingReverse lst =
  let rev xs a = foldl (flip (:)) a xs
  in rev lst []
