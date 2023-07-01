import Data.List (mapAccumL)

cumu :: [[Integer]]
cumu = [1] : map (scanl (+) 0) rows

rows :: [[Integer]]
rows = snd $ mapAccumL f [] cumu where
    f r row = (rr, new_row) where
        new_row = map head rr
        rr = map tailKeepOne (row:r)
    tailKeepOne [x] = [x]
    tailKeepOne (_:xs) = xs

sums n = cumu !! n !! n
--curiously, the following seems to be faster
--sums = sum . (rows!!)

main :: IO ()
main = do
    mapM_ print $ take 10 rows
    mapM_ (print.sums) [23, 123, 1234, 12345]
