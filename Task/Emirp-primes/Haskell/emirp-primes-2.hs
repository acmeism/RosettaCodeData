 λ> let emirp p = let q=(read.reverse.show) p in q /= p && noDivsBy primesW q

 λ> take 20 . filter emirp $ primesW
[13,17,31,37,71,73,79,97,107,113,149,157,167,179,199,311,337,347,359,389]

 λ> filter emirp . takeWhile (< 8000) . dropWhile (< 7700) $ primesW
[7717,7757,7817,7841,7867,7879,7901,7927,7949,7951,7963]  --  0.02 secs

 λ> (!! (10000-1)) . filter emirp $ primesW
948349                                                    -- 0.69 secs
