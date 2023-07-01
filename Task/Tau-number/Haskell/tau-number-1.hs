tau :: Integral a => a -> a
tau n | n <= 0 = error "Not a positive integer"
tau n = go 0 (1, 1)
    where
    yo i = (i, i * i)
    go r (i, ii)
        | n < ii = r
        | n == ii = r + 1
        | 0 == mod n i = go (r + 2) (yo $ i + 1)
        | otherwise = go r (yo $ i + 1)

isTau :: Integral a => a -> Bool
isTau n = 0 == mod n (tau n)

main = print . take 100 . filter isTau $ [1..]
