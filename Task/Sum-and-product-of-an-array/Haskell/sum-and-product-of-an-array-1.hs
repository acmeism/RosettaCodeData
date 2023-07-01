values = [1..10]

s = sum values           -- the easy way
p = product values

s1 = foldl (+) 0 values  -- the hard way
p1 = foldl (*) 1 values
