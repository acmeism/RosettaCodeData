values = [1..10]

s = sum values           -- the easy way
p = product values

s' = foldl (+) 0 values  -- the hard way
p' = foldl (*) 1 values
