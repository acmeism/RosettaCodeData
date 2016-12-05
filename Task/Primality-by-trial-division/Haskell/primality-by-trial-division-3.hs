isPrime n = n > 1 && []==[i | i <- [2..n-1], rem n i == 0]
