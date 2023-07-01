brackets = filter isMatching
           $ [1.. ] >>= (`replicateM` "[]{}")
