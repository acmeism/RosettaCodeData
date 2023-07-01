import Data.List

longest xs ys = if length xs > length ys then xs else ys

lcs xs ys = head $ foldr(\xs -> map head. scanr1 f. zipWith (\x y -> [x,y]) xs) e m where
    m = map (\x -> flip (++) [[]] $ map (\y -> [x | x==y]) ys) xs
    e = replicate (length ys) []
    f [a,b] [c,d]
     | null a = longest b c: [b]
     | otherwise = (a++d):[b]
