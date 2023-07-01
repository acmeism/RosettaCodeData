tpose [ms] = [[m] | m <- ms]
tpose (ms:mss) = zipWith (:) ms (tpose mss)
