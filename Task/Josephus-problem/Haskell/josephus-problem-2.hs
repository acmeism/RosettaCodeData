jseq n k = f n [1 .. n] where
    f 0 _ = []
    f m s = x:f (m-1) (right ++ left) where
        (left,x:right) = splitAt ((k-1) `mod` m) s

-- the final survivor is ((k + ...((k + ((k + 0)`mod` 1)) `mod` 2) ... ) `mod` n)
jos n k = 1 + foldl (\x->((k+x)`mod`)) 0 [2..n]

main = do
    print $ jseq 41 3
    print $ jos 10000 100
