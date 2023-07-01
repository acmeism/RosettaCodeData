perm :: Integer -> Integer -> Integer
perm n k = product [n-k+1..n]

comb :: Integer -> Integer -> Integer
comb n k = perm n k `div` product [1..k]

main :: IO ()
main = do
        let showBig maxlen b =
                let st = show b
                    stlen = length st
                in if stlen < maxlen then st else take maxlen st ++ "... ("  ++ show (stlen-maxlen) ++  " more digits)"

        let showPerm pr =
                putStrLn $ "perm(" ++ show n ++ "," ++ show k ++ ") = "  ++ showBig 40 (perm n k)
                where n = fst pr
                      k = snd pr

        let showComb pr =
                putStrLn $ "comb(" ++ show n ++ "," ++ show k ++ ") = "  ++ showBig 40 (comb n k)
                where n = fst pr
                      k = snd pr

        putStrLn "A sample of permutations from 1 to 12:"
        mapM_  showPerm [(n, n `div` 3) | n <- [1..12] ]

        putStrLn ""
        putStrLn "A sample of combinations from 10 to 60:"
        mapM_  showComb [(n, n `div` 3) | n <- [10,20..60] ]

        putStrLn ""
        putStrLn "A sample of permutations from 5 to 15000:"
        mapM_  showPerm [(n, n `div` 3) | n <- [5,50,500,1000,5000,15000] ]

        putStrLn ""
        putStrLn "A sample of combinations from 100 to 1000:"
        mapM_  showComb [(n, n `div` 3) | n <- [100,200..1000] ]
