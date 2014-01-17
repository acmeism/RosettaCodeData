mulfac k = 1:s where s = [1 .. k] ++ zipWith (*) s [k+1..]

-- for single n
mulfac1 k n = product [n, n-k .. 1]

main = mapM_ (print . take 10 . tail . mulfac) [1..5]
