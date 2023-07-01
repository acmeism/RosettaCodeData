 λ> take 20 primesW
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71]

 λ> takeWhile (< 150) . dropWhile (< 100) $ primesW
[101,103,107,109,113,127,131,137,139,149]

 λ> length . takeWhile (< 8000) . dropWhile (< 7700) $ primesW
30

 λ> (!! (10000-1)) primesW
104729
