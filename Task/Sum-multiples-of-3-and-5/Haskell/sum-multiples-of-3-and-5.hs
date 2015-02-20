import Data.List (nub)

sumMul n f = f * n1 * (n1 + 1) `div` 2 where n1 = (n - 1) `div` f
sum35 n = sumMul n 3 + sumMul n 5 - sumMul n 15

-- below are for variable length inputs
pairLCM [] = []
pairLCM (x:xs) = map (lcm x) xs ++ pairLCM xs

sumMulS _ [] = 0
sumMulS n s = sum (map (sumMul n) ss) - sumMulS n (pairLCM ss)
    where ss = nub s

main = do
    print $ sum35 1000
    print $ sum35 100000000000000000000000000000000
    print $ sumMulS 1000 [3,5]
    print $ sumMulS 10000000 [2,3,5,7,11,13]
