mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs). zipWith (\vs u -> map (u*) vs) vss) uss

bubble::([a] -> c) -> (c -> c -> Bool) -> [[a]] -> [[b]] -> ([[a]],[[b]])
bubble _ _ [] ts         = ([],ts)
bubble _ _ rs []         = (rs,[])
bubble f g (r:rs) (t:ts) = bub r t (f r) rs ts [] []
  where
  bub l k _ [] _ xs ys          = (l:xs,k:ys)
  bub l k _ _ [] xs ys          = (l:xs,k:ys)
  bub l k m (u:us) (v:vs) xs ys = ans
    where
    mu = f u
    ans | g m mu    = bub l k m us vs (u:xs) (v:ys)
        | otherwise = bub u v mu us vs (l:xs) (k:ys)

pivot::Num a => [a] -> [a] -> [[a]] -> [[a]] -> ([[a]],[[a]])
pivot xs ks ys ls = go ys ls [] []
  where
  x              = head xs
  fun r          = zipWith (\u v ->  u*r - v*x)
  val rs ts      = let f = fun (head rs) in (tail $ f xs rs,f ks ts)
  go [] _ us vs  = (us,vs)
  go _ [] us vs  = (us,vs)
  go rs ts us vs = go (tail rs) (tail ts) (es:us) (fs:vs)
    where (es,fs) = val (head rs) (head ts)

triangle::(Num a,Ord a) => [[a]] -> [[a]] -> ([[a]],[[a]])
triangle as bs = go (as,bs) [] []
  where
  go ([],_) us vs  = (us,vs)
  go (_,[]) us vs  = (us,vs)
  go (rs,ts) us vs = ans
    where
    (xs:ys,ks:ls) = bubble (abs.head) (>=) rs ts
    ans = go (pivot xs ks ys ls) (xs:us) (ks:vs)

solveTriangle::(Fractional a,Eq a) => [[a]] -> [[a]] -> [[a]]
solveTriangle [] _ = []
solveTriangle _ [] = []
solveTriangle as _ | not.null.dropWhile ((/= 0).head) $ as = []
solveTriangle ([c]:as) (b:bs) = go as bs [map (/c) b]
  where
  val us vs ws = let u = head us in map (/u) $ zipWith (-) vs (head $ mult [tail us] ws)
  go [] _ zs          = zs
  go _ [] zs          = zs
  go (x:xs) (y:ys) zs = go xs ys $ (val x y zs):zs

solveGauss:: (Fractional a, Ord a) => [[a]] -> [[a]] -> [[a]]
solveGauss as bs = uncurry solveTriangle $ triangle as bs

matI::(Num a) => Int -> [[a]]
matI n = [ [fromIntegral.fromEnum $ i == j | j <- [1..n]] | i <- [1..n]]

task::[[Rational]] -> [[Rational]] -> IO()
task a b = do
  let x         = solveGauss a b
  let u         = map (map fromRational) x
  let y         = mult a x
  let identity  = matI (length x)
  let a1        = solveGauss a identity
  let h         = mult a a1
  let z         = mult a1 b
  putStrLn "a ="
  mapM_ print a
  putStrLn "b ="
  mapM_ print b
  putStrLn "solve: a * x = b => x = solveGauss a b ="
  mapM_ print x
  putStrLn "u = fromRationaltoDouble x ="
  mapM_ print u
  putStrLn "verification: y = a * x = mult a x ="
  mapM_ print y
  putStrLn $ "test: y == b = "
  print $ y == b
  putStrLn "identity matrix: identity ="
  mapM_ print identity
  putStrLn "find: a1 = inv(a) => solve: a * a1 = identity => a1 = solveGauss a identity ="
  mapM_ print a1
  putStrLn "verification: h = a * a1 = mult a a1 ="
  mapM_ print h
  putStrLn $ "test: h == identity = "
  print $ h == identity
  putStrLn "z = a1 * b = mult a1 b ="
  mapM_ print z
  putStrLn "test: z == x ="
  print $ z == x

main = do
  let a  = [[1.00, 0.00, 0.00,  0.00,  0.00,   0.00],
            [1.00, 0.63, 0.39,  0.25,  0.16,   0.10],
            [1.00, 1.26, 1.58,  1.98,  2.49,   3.13],
            [1.00, 1.88, 3.55,  6.70, 12.62,  23.80],
            [1.00, 2.51, 6.32, 15.88, 39.90, 100.28],
            [1.00, 3.14, 9.87, 31.01, 97.41, 306.02]]
  let b = [[-0.01], [0.61], [0.91], [0.99], [0.60], [0.02]]
  task a b
