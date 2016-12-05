import Data.List
factors_o n = ds ++ [r | mod n r == 0] ++ reverse (map (n `div`) ds)
        where
        r = floor (sqrt (fromIntegral n))
        ds = [i | i <- [1..r-1], mod n i == 0]
