let rec rI2cf n d =
    if d = 0I then []
    else let q = n / d in (decimal)q :: (rI2cf d (n - q * d))
