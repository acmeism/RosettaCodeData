nums = [1..10]

summation = foldl (+) 0 nums
product = foldl (*) 1 nums
concatenation = foldr (\num s -> show num ++ s) "" nums
