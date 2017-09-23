import Data.List
factors_o n = ds ++ [r | (d,0) <- [divMod n r], r <- r:[d | d>r]] ++ reverse (map (n `div`) ds)
        where
        r = floor (sqrt (fromIntegral n))
        ds = [i | i <- [1..r-1], mod n i == 0]
