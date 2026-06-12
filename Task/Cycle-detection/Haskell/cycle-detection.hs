import Data.List (findIndex)

findCycle :: Eq a => [a] -> Maybe ([a], Int, Int)
findCycle lst =
  do l <- findCycleLength lst
     mu <- findIndex (uncurry (==)) $ zip lst (drop l lst)
     let c = take l $ drop mu lst
     return (c, l, mu)

findCycleLength :: Eq a => [a] -> Maybe Int
findCycleLength [] = Nothing
findCycleLength (x:xs) =
  let loop _ _ _ [] = Nothing
      loop pow lam x (y:ys)
        | x == y     = Just lam
        | pow == lam = loop (2*pow) 1 y ys
        | otherwise  = loop pow (1+lam) x ys
  in loop 1 1 x xs
