hamming = 1 : map (2*) hamming `union` map (3*) hamming `union` map (5*) hamming

union a@(x:xs) b@(y:ys) = case compare x y of
            LT -> x : union  xs  b
            EQ -> x : union  xs  ys
            GT -> y : union  a   ys

main = do
    print $ take 20 hamming
    print  (hamming !! (1691-1), hamming !! (1692-1))
    print $ hamming !! (1000000-1)

-- Output:
-- [1,2,3,4,5,6,8,9,10,12,15,16,18,20,24,25,27,30,32,36]
-- (2125764000,2147483648)
-- 519312780448388736089589843750000000000000000000000000000000000000000000000000000000
