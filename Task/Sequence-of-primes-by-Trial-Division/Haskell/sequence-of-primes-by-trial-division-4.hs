Data.List.unfoldr (\(x:xs) -> Just (x, filter ((> 0).(`rem` x)) xs)) [2..]
