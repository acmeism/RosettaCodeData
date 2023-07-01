fac = product . enumFromTo 1

binCoef n k = fac n `div` (fac k * fac (n - k))

pascal = ((fmap . binCoef) <*> enumFromTo 0) . pred
