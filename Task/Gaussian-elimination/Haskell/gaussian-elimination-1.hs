isMatrix xs = null xs || all ((== (length.head $ xs)).length) xs

isSquareMatrix xs = null xs || all ((== (length xs)).length) xs

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs). zipWith (\vs u -> map (u*) vs) vss) uss

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
    idmax = snd.minimum.flip zip [0..].map (negate.abs.head) $ xs
    go ys = let (us,vs) = splitAt idmax ys in vs ++ us

main = do
  let a  = [[1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
            [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
            [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
            [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
            [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
            [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]]
  let b = [[-0.01], [0.61], [0.91], [0.99], [0.60], [0.02]]
  mapM_ print $ gauss a b
