integrate _ []     = 0
integrate f (m:ms) = sum $ zipWith (gaussLegendre 5 f) (m:ms) ms
