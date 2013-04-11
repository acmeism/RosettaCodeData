import Data.List (delete, sort)

-- Functions by Reinhard Zumkeller
ffr n = rl !! (n - 1) where
   rl = 1 : fig 1 [2 ..]
   fig n (x : xs) = n' : fig n' (delete n' xs) where n' = n + x

ffs n = rl !! n where
   rl = 2 : figDiff 1 [2 ..]
   figDiff n (x : xs) = x : figDiff n' (delete n' xs) where n' = n + x

main = do
    print $ map ffr [1 .. 10]
    let i1000 = sort (map ffr [1 .. 40] ++ map ffs [1 .. 960])
    print (i1000 == [1 .. 1000])
