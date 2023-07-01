isMatrix xs = null xs || all ((== (length.head $ xs)).length) xs

isSquareMatrix xs = null xs || all ((== (length xs)).length) xs

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs). zipWith (\vs u -> map (u*) vs) vss) uss

matI::(Num a) => Int -> [[a]]
matI n = [ [fromIntegral.fromEnum $ i == j | j <- [1..n]] | i <- [1..n]]

inversion xs = gauss xs (matI $ length xs)

gauss::[[Double]] -> [[Double]] -> [[Double]]
gauss xs bs = map (map fromRational) $ solveGauss (toR xs) (toR bs)
    where toR = map $ map toRational

solveGauss:: (Fractional a, Ord a) => [[a]] -> [[a]] -> [[a]]
solveGauss xs bs | null xs || null bs || length xs /= length bs || (not $ isSquareMatrix xs) || (not $ isMatrix bs) = []
                 | otherwise = uncurry solveTriangle $ triangle xs bs

solveTriangle::(Fractional a,Eq a) => [[a]] -> [[a]] -> [[a]]
solveTriangle us _ | not.null.dropWhile ((/= 0).head) $ us = []
solveTriangle ([c]:as) (b:bs) = go as bs [map (/c) b]
  where
  val us vs ws = let u = head us in map (/u) $ zipWith (-) vs (head $ mult [tail us] ws)
  go [] _ zs          = zs
  go _ [] zs          = zs
  go (x:xs) (y:ys) zs = go xs ys $ (val x y zs):zs

triangle::(Num a, Ord a) => [[a]] -> [[a]] -> ([[a]],[[a]])
triangle xs bs = triang ([],[]) (xs,bs)
    where
    triang ts (_,[]) = ts
    triang ts ([],_) = ts
    triang (os,ps) zs = triang (us:os,cs:ps).unzip $ [(fun tus vs, fun cs es) | (v:vs,es) <- zip uss css,let fun = zipWith (\x y -> v*x - u*y)]
        where ((us@(u:tus)):uss,cs:css) = bubble zs

bubble::(Num a, Ord a) => ([[a]],[[a]]) -> ([[a]],[[a]])
bubble (xs,bs) = (go xs, go bs)
    where
    idmax = snd.maximum.flip zip [0..].map (abs.head) $ xs
    go ys = let (us,vs) = splitAt idmax ys in vs ++ us

main = do
  let a = [[1, 2, 3], [4, 1, 6], [7, 8, 9]]
  let b = [[2, -1, 0], [-1, 2, -1], [0, -1, 2]]
  putStrLn "inversion a ="
  mapM_ print $ inversion a
  putStrLn "\ninversion b ="
  mapM_ print $ inversion b
