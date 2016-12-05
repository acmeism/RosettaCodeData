foldr (\x r -> x : filter ((> 0).(`rem` x)) r) [] [2..]
