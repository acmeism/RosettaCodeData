λ> :set +s
λ> prime 10000
104729
(0.32 secs, 179,899,272 bytes)
λ> length $ dropWhile (< 7700) $ takeWhile (< 8000) $  map prime [1..]
30
(3.09 secs, 3,418,225,920 bytes)
λ> dropWhile (< 100) $ takeWhile (< 150) $ map prime [1..]
[101,103,107,109,113,127,131,137,139,149]
(0.02 secs, 20,239,464 bytes)
λ> map prime [1..20]
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71]
(0.01 secs, 10,485,208 bytes)
