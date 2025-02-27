fac n
    | n >= 0    = go 1 n
    | otherwise = error "Negative factorial!"
        where go acc 0 = acc
              go acc n = go (acc * n) (n - 1)
