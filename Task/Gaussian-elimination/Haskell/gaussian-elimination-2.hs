foldlZipWith::(a -> b -> c) -> (d -> c -> d) -> d -> [a] -> [b]  -> d
foldlZipWith _ _ u [] _          = u
foldlZipWith _ _ u _ []          = u
foldlZipWith f g u (x:xs) (y:ys) = foldlZipWith f g (g u (f x y)) xs ys

foldl1ZipWith::(a -> b -> c) -> (c -> c -> c) -> [a] -> [b] -> c
foldl1ZipWith _ _ [] _          = error "First list is empty"
foldl1ZipWith _ _ _ []          = error "Second list is empty"
foldl1ZipWith f g (x:xs) (y:ys) = foldlZipWith f g (f x y) xs ys

multAdd::(a -> b -> c) -> (c -> c -> c) -> [[a]] -> [[b]] -> [[c]]
multAdd f g xs ys = map (\us -> foldl1ZipWith (\u vs -> map (f u) vs) (zipWith g) us ys) xs

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult xs ys = multAdd (*) (+) xs ys

triangle::(Fractional a, Ord a) => [[a]] -> [[a]] -> (a,[(([a],[a]),Int)])
triangle as bs = pivot 1 [] $ zipWith3 (\x y i -> ((x,y),i)) as bs [(0::Int)..]
  where
  good rs ts = (abs.head.fst.fst $ ts) <= (abs.head.fst.fst $ rs)
  go (us,vs) ((os,ps),i) = if o == 0 then ((rs,f vs ps),i) else ((f us rs,f vs ps),i)
    where
    (o,rs) = (head os,tail os)
    f = zipWith (\x y -> y - x*o)
  change i (ys:zs) = map (\xs -> if (==i).snd $ xs then ys else xs) zs
  pivot d ls [] = (d,ls)
  pivot d ls zs@((_,j):ys) = if u == 0 then (0,ls) else pivot e (ps:ls) ws
    where
    e  = if i == j then u*d else -u*d
    ws = map (go (map (/u) us,map (/u) vs)) $ if i == j then ys else change i zs
    ps@((u:us,vs),i) = foldl1 (\rs ts ->  if good rs ts then rs else ts) zs

-- ((det,sol),permutation) = gauss as bs
-- det = determinant as
-- sol is solution of: as * sol = bs
-- perm is a permutation with: (matPerm perm) * as * sol = (matPerm perm) * bs
gauss::(Fractional a,Ord a) => [[a]] -> [[a]] -> ((a,[[a]]),[Int])
gauss as bs = if 0 == det then ((0,[]),[]) else solveTriangle ms
  where
  (det,ms) = triangle as bs
  solveTriangle ((([c],b),i):sys) = go sys [map (/c) b] [i]
    where
    val us vs ws = let u = head us in map (/u) $ zipWith (-) vs (head $ mult [tail us] ws)
    go [] zs is        = ((det,zs),is)
    go (((x,y),i):sys) zs is = go sys ((val x y zs):zs) (i:is)

solveGauss::(Fractional a,Ord a) => [[a]] -> [[a]] -> [[a]]
solveGauss as = snd.fst.gauss as

matI::Num a => Int -> [[a]]
matI n = [ [fromIntegral.fromEnum $ i == j | i <- [1..n]] | j <- [1..n]]

matPerm::Num a => [Int] -> [[a]]
matPerm ns = [ [fromIntegral.fromEnum $ i == j | (j,_) <- zip [0..] ns] | i <- ns]

task::[[Rational]] -> [[Rational]] -> IO()
task a b = do
  let ((d,x),perm)   = gauss a b
  let ps             = matPerm perm
  let u              = map (map fromRational) x
  let y              = mult a x
  let identity       = matI (length x)
  let a1             = solveGauss a identity
  let h              = mult a a1
  let z              = mult a1 b
  putStrLn "d = determinant a ="
  print d
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
  putStrLn "ps is the permutation associated to matrix a and ps ="
  mapM_ print ps
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
  let b = [[-0.01], [0.61], [0.91],  [0.99],  [0.60], [0.02]]
  task a b
