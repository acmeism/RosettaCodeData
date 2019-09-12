fac = product . enumFromTo 1

binCoef n k = (fac n) `div` ((fac k) * (fac $ n - k))

pascal n = map (binCoef $ n - 1) [0..n-1]
